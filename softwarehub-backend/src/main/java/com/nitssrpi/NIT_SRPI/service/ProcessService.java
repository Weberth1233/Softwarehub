package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.Infra.security.SecurityService;
import com.nitssrpi.NIT_SRPI.controller.exceptions.OperationNotAllowedException;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessClassificationRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessStatusCountDTO;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.*;
import com.nitssrpi.NIT_SRPI.repository.specs.ProcessSpecs;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProcessService {

    private final ProcessRepository repository;
    private final UserRepository userRepository;
    private final IpTypesRepository ipTypesRepository;
  //  private final NiceClassificationRepository niceClassificationRepository;
    private final ApplicationFieldRepository applicationFieldRepository;
    private final ExternalAuthorRepository externalAuthorRepository;
    private final SecurityService securityService;

    @Transactional
    public Process save(Process process) {
        User user = securityService.getAuthenticatedUser();

        process.setCreator(user);
        process.setStatus(StatusProcess.PENDENTE_DISTRIBUICAO_COTAS);
//        process.setNiceClassification(null);

        IpTypes type = prepareProcessBasicRelations(process);

        addRequiredAttachments(process, type);

        return repository.save(process);
    }

    @Transactional
    public void update(Process process) {
        if (process.getId() == null) {
            throw new IllegalArgumentException("Para atualizar é necessário informar o ID do processo!");
        }

        Process processDb = repository.findById(process.getId())
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado"));

        if (processDb.getStatus() == StatusProcess.FINALIZADO) {
            throw new OperationNotAllowedException("Processo finalizado não pode ser alterado.");
        }

        if (processDb.getStatus() == StatusProcess.INATIVO) {
            throw new OperationNotAllowedException("Processo inativo não pode ser alterado.");
        }

        processDb.setTitle(process.getTitle());
        processDb.setFormData(process.getFormData());

        prepareProcessBasicRelations(process);

        processDb.setIpType(process.getIpType());
        processDb.setAuthors(process.getAuthors());
        processDb.setExternalAuthors(process.getExternalAuthors());

        if (processDb.getStatus() == StatusProcess.CORRECAO) {
            processDb.setStatus(StatusProcess.CORRIGIDO);
        }

        repository.save(processDb);
    }

    @Transactional
    public void classifyProcess(Long processId, ProcessClassificationRequestDTO requestDTO) {
        Process process = repository.findById(processId)
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado"));

        validateCanClassify(process);

        for(Long applicationFieldId: requestDTO.applicationFields()){
            ApplicationField applicationField =  applicationFieldRepository.findById(applicationFieldId).orElseThrow(() -> new EntityNotFoundException("Campo de aplicação não encontrado!"));
            process.getApplicationFields().add(applicationField);
        }

        process.setStatus(StatusProcess.CLASSIFICADO);
        repository.save(process);
    }

    @Transactional
    public void updateClassification(Long processId, ProcessClassificationRequestDTO requestDTO) {
        Process process = repository.findById(processId)
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado"));

        process.getApplicationFields().clear();

        for (Long applicationFieldId : requestDTO.applicationFields()) {
            ApplicationField applicationField = applicationFieldRepository.findById(applicationFieldId)
                    .orElseThrow(() -> new EntityNotFoundException("Campo de aplicação não encontrado!"));

            process.getApplicationFields().add(applicationField);
        }

        process.setStatus(StatusProcess.CLASSIFICADO);

        repository.save(process);
    }

    @Transactional
    public void updateStatus(Long id, StatusProcess newStatus) {
        Process process = repository.findById(id)
                .orElseThrow(() ->
                        new EntityNotFoundException("Processo não encontrado com ID: " + id)
                );

        validateStatusTransition(process, newStatus);

        process.setStatus(newStatus);

        repository.save(process);
    }

    private void validateStatusTransition(Process process, StatusProcess newStatus) {
        StatusProcess currentStatus = process.getStatus();

        if (currentStatus == StatusProcess.FINALIZADO) {
            throw new OperationNotAllowedException(
                    "Processo finalizado não pode ter seu status alterado."
            );
        }

        if (currentStatus == StatusProcess.INATIVO) {
            throw new OperationNotAllowedException(
                    "Processo inativo não pode ter seu status alterado."
            );
        }

        if (newStatus == StatusProcess.CLASSIFICADO) {
            validateCanClassify(process);
        }

        if (newStatus == StatusProcess.FINALIZADO) {
            validateCanFinish(process);
        }

        if (newStatus == StatusProcess.CORRIGIDO && currentStatus != StatusProcess.CORRECAO) {
            throw new OperationNotAllowedException(
                    "Somente processos em correção podem ser marcados como corrigidos."
            );
        }
    }

    private void validateCanClassify(Process process) {
        if (process.getStatus() == StatusProcess.PENDENTE_DISTRIBUICAO_COTAS) {
            throw new OperationNotAllowedException(
                    "O processo ainda está aguardando a distribuição de cotas."
            );
        }

        if (process.getStatus() == StatusProcess.PENDENTE_DOCUMENTACAO) {
            throw new OperationNotAllowedException(
                    "O processo ainda está aguardando o envio da documentação."
            );
        }

        if (process.getStatus() == StatusProcess.CORRECAO) {
            throw new OperationNotAllowedException(
                    "O processo está em correção e não pode ser classificado."
            );
        }

        if (process.getStatus() == StatusProcess.FINALIZADO) {
            throw new OperationNotAllowedException(
                    "Processo finalizado não pode ser classificado novamente."
            );
        }

        if (process.getStatus() == StatusProcess.INATIVO) {
            throw new OperationNotAllowedException(
                    "Processo inativo não pode ser classificado."
            );
        }

        validateHasQuotaDistribution(process);
        validateAllAttachmentsSigned(process);
    }

    private void validateCanFinish(Process process) {
        if (process.getStatus() == StatusProcess.CORRECAO) {
            throw new OperationNotAllowedException(
                    "O processo está em correção e não pode ser finalizado."
            );
        }

        if (process.getStatus() == StatusProcess.CORRIGIDO) {
            throw new OperationNotAllowedException(
                    "O processo foi corrigido e precisa ser classificado antes de ser finalizado."
            );
        }

        if (process.getStatus() == StatusProcess.PENDENTE_DISTRIBUICAO_COTAS) {
            throw new OperationNotAllowedException(
                    "O processo ainda está aguardando a distribuição de cotas."
            );
        }

        if (process.getStatus() == StatusProcess.PENDENTE_DOCUMENTACAO) {
            throw new OperationNotAllowedException(
                    "O processo ainda está aguardando o envio da documentação."
            );
        }

        if (process.getStatus() == StatusProcess.COTAS_DISTRIBUIDAS) {
            throw new OperationNotAllowedException(
                    "O processo ainda precisa ser classificado antes de ser finalizado."
            );
        }

        if (process.getStatus() != StatusProcess.CLASSIFICADO) {
            throw new OperationNotAllowedException(
                    "O processo só pode ser finalizado após ser classificado."
            );
        }

        validateHasQuotaDistribution(process);
        validateAllAttachmentsSigned(process);
    }

    private void validateHasQuotaDistribution(Process process) {
        if (process.getRoyaltyDistributions() == null ||
                process.getRoyaltyDistributions().isEmpty()) {
            throw new OperationNotAllowedException(
                    "O processo ainda não possui distribuição de cotas."
            );
        }

        boolean hasActiveDistribution = process.getRoyaltyDistributions()
                .stream()
                .anyMatch(distribution ->
                        distribution.getStatus() == RoyaltyDistributionStatus.ACTIVE
                );

        if (!hasActiveDistribution) {
            throw new OperationNotAllowedException(
                    "O processo não possui uma distribuição de cotas ativa."
            );
        }
    }

    private void validateAllAttachmentsSigned(Process process) {
        if (process.getAttachments() == null || process.getAttachments().isEmpty()) {
            return;
        }

        process.getAttachments()
                .stream()
                .filter(att -> "PENDING".equalsIgnoreCase(att.getStatus()))
                .findFirst()
                .ifPresent(att -> {
                    throw new OperationNotAllowedException(
                            "Há documento pendente para assinatura: " + att.getDisplayName()
                    );
                });
    }

    private void addRequiredAttachments(Process process, IpTypes type) {
        if (type.getRequiredDocuments() == null || type.getRequiredDocuments().isEmpty()) {
            return;
        }

        if (process.getAttachments() == null) {
            process.setAttachments(new ArrayList<>());
        }

        for (IpTypeDocument docModelo : type.getRequiredDocuments()) {
            Attachment novoAnexo = new Attachment();

            novoAnexo.setDisplayName(docModelo.getDisplayName());
            novoAnexo.setTemplateFilePath(docModelo.getTemplateFilePath());
            novoAnexo.setStatus("PENDING");
            novoAnexo.setProcess(process);

            process.getAttachments().add(novoAnexo);
        }
    }

    private IpTypes prepareProcessBasicRelations(Process process) {
        if (process.getIpType() == null || process.getIpType().getId() == null) {
            throw new IllegalArgumentException("Tipo de PI é obrigatório!");
        }

        IpTypes type = ipTypesRepository.findById(process.getIpType().getId())
                .orElseThrow(() -> new EntityNotFoundException("Tipo de PI não encontrado!"));

        process.setIpType(type);

        List<User> validAuthors = validateAuthors(process.getAuthors());
        List<ExternalAuthor> validExternalAuthors = validateExternalAuthors(process.getExternalAuthors());

        if (validAuthors.isEmpty() && validExternalAuthors.isEmpty()) {
            throw new IllegalArgumentException(
                    "Necessário adicionar pelo menos um autor interno ou externo ao processo!"
            );
        }

        process.setAuthors(validAuthors);
        process.setExternalAuthors(validExternalAuthors);

        return type;
    }

    private List<User> validateAuthors(List<User> authors) {
        if (authors == null || authors.isEmpty()) {
            return new ArrayList<>();
        }

        List<User> validAuthors = new ArrayList<>();

        for (User author : authors) {
            if (author.getId() == null) {
                throw new IllegalArgumentException("ID do autor interno é obrigatório!");
            }

            User currentAuthor = userRepository.findById(author.getId())
                    .orElseThrow(() -> new EntityNotFoundException(
                            "Autor interno não encontrado com ID: " + author.getId()
                    ));

            validAuthors.add(currentAuthor);
        }

        return validAuthors;
    }

    private List<ExternalAuthor> validateExternalAuthors(List<ExternalAuthor> externalAuthors) {
        if (externalAuthors == null || externalAuthors.isEmpty()) {
            return new ArrayList<>();
        }

        List<ExternalAuthor> validExternalAuthors = new ArrayList<>();

        for (ExternalAuthor externalAuthor : externalAuthors) {
            if (externalAuthor.getId() == null) {
                throw new IllegalArgumentException("ID do autor externo é obrigatório!");
            }

            ExternalAuthor currentExternalAuthor = externalAuthorRepository.findById(externalAuthor.getId())
                    .orElseThrow(() -> new EntityNotFoundException(
                            "Autor externo não encontrado com ID: " + externalAuthor.getId()
                    ));

            validExternalAuthors.add(currentExternalAuthor);
        }

        return validExternalAuthors;
    }

    @Transactional
    public void refreshStatusAfterRequirementsChange(Long processId) {
        Process process = repository.findById(processId)
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado"));

        if (process.getStatus() == StatusProcess.FINALIZADO) {
            throw new OperationNotAllowedException("Processo finalizado não pode ser alterado.");
        }

        if (process.getStatus() == StatusProcess.INATIVO) {
            throw new OperationNotAllowedException("Processo inativo não pode ser alterado.");
        }

        StatusProcess nextStatus = resolveNextStatus(process);

        process.setStatus(nextStatus);
        repository.save(process);
    }

    private StatusProcess resolveNextStatus(Process process) {
        boolean hasActiveDistribution = hasActiveQuotaDistribution(process);
        boolean hasPendingDocumentation = hasPendingDocumentation(process);

        if (!hasActiveDistribution) {
            return StatusProcess.PENDENTE_DISTRIBUICAO_COTAS;
        }

        if (hasPendingDocumentation) {
            return StatusProcess.PENDENTE_DOCUMENTACAO;
        }

        if (process.getStatus() == StatusProcess.CORRECAO ||
                process.getStatus() == StatusProcess.CORRIGIDO) {
            return StatusProcess.CORRIGIDO;
        }

        if (process.getStatus() == StatusProcess.CLASSIFICADO) {
            return StatusProcess.CLASSIFICADO;
        }

        return StatusProcess.COTAS_DISTRIBUIDAS;
    }

    private boolean hasActiveQuotaDistribution(Process process) {
        return process.getRoyaltyDistributions() != null &&
                process.getRoyaltyDistributions()
                        .stream()
                        .anyMatch(distribution ->
                                distribution.getStatus() == RoyaltyDistributionStatus.ACTIVE
                        );
    }

    private boolean hasPendingDocumentation(Process process) {
        return process.getAttachments() != null &&
                process.getAttachments()
                        .stream()
                        .anyMatch(att -> "PENDING".equalsIgnoreCase(att.getStatus()));
    }

    public Page<Process> searchProcess(
            String title,
            StatusProcess statusProcess,
            Integer page,
            Integer pageSize
    ) {
        Specification<Process> specs = Specification.where((root, query, cb) -> cb.conjunction());
        specs = specs.and(ProcessSpecs.differentStatusProcess(StatusProcess.INATIVO));

        if (title != null && !title.isEmpty()) {
            specs = specs.and(ProcessSpecs.likeTitle(title));
        }

        if (statusProcess != null) {
            specs = specs.and(ProcessSpecs.equalStatusProcess(statusProcess));
        }

        Pageable pageRequest = PageRequest.of(
                page,
                pageSize,
                Sort.by(Sort.Direction.DESC, "updatedAt")
        );

        return repository.findAll(specs, pageRequest);
    }

    public Page<Process> userProcesses(
            String title,
            StatusProcess statusProcess,
            Integer page,
            Integer pageSize
    ) {
        User user = securityService.getAuthenticatedUser();

        if (user.getRole() == UserRole.USER) {
            Specification<Process> specs = Specification.where(
                    ProcessSpecs.creatorOrAuthor(user.getId()).and(ProcessSpecs.differentStatusProcess(StatusProcess.INATIVO))
            );

            if (title != null && !title.isEmpty()) {
                specs = specs.and(ProcessSpecs.likeTitle(title));
            }

            if (statusProcess != null) {
                specs = specs.and(ProcessSpecs.equalStatusProcess(statusProcess));
            }

            Pageable pageable = PageRequest.of(
                    page,
                    pageSize,
                    Sort.by(Sort.Direction.DESC, "createdAt")
            );

            return repository.findAll(specs, pageable);
        }

        return searchProcess(title, statusProcess, page, pageSize);
    }

    public Optional<Process> getById(Long id) {
        return repository.findById(id);
    }

    public void delete(Process process) {
        process.setStatus(StatusProcess.INATIVO);
        repository.save(process);
    }

    public List<Process> getAllProcess() {
        return repository.findAll();
    }

    public List<ProcessStatusCountDTO> countProcessStatus() {
        User user = securityService.getAuthenticatedUser();

        if (user.getRole() == UserRole.USER) {
            System.out.println(user.getEmail() + " " + user.getFullName());
            return repository.countProcessStatus(user.getId());
        }

        return repository.countProcessStatusAdmin();
    }
}