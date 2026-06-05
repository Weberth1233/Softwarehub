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
    private final NiceClassificationRepository niceClassificationRepository;
    private  final ExternalAuthorRepository externalAuthorRepository;
    private final SecurityService securityService;

    @Transactional
    public Process save(Process process) {
        User user = securityService.getAuthenticatedUser();

        process.setCreator(user);
        process.setStatus(StatusProcess.EM_ANDAMENTO);
        process.setNiceClassification(null);
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

        processDb.setTitle(process.getTitle());
        processDb.setFormData(process.getFormData());

        prepareProcessBasicRelations(process);

        processDb.setIpType(process.getIpType());
        processDb.setAuthors(process.getAuthors());
        processDb.setExternalAuthors(process.getExternalAuthors());

        repository.save(processDb);
    }

    private void addRequiredAttachments(Process process, IpTypes type) {
        if (type.getRequiredDocuments() == null || type.getRequiredDocuments().isEmpty()) {
            return;
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
            throw new IllegalArgumentException("Necessário adicionar pelo menos um autor interno ou externo ao processo!");
        }

        process.setAuthors(validAuthors);
        process.setExternalAuthors(validExternalAuthors);

        return type;
    }


    @Transactional
    public void classifyProcess(Long processId, ProcessClassificationRequestDTO requestDTO){
        Process process = repository.findById(processId).orElseThrow(() ->
                new EntityNotFoundException("Processo não encontrado")
        );
        NiceClassification niceClassification =
                niceClassificationRepository.findById(requestDTO.niceClassCode())
                        .orElseThrow(() ->
                                new EntityNotFoundException("Classe NICE não encontrada")
                        );
        process.setNiceClassification(niceClassification);
        repository.save(process);
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

    public Page<Process> searchProcess(String title, StatusProcess statusProcess, Integer page, Integer pageSize){
        Specification<Process> specs = Specification.where((root, query, cb) -> cb.conjunction());
        if(title != null){
            specs = specs.and(ProcessSpecs.likeTitle(title));
        }
        if(statusProcess != null){
            specs = specs.and(ProcessSpecs.equalStatusProcess(statusProcess));
        }
        Pageable pageRequest = PageRequest.of(page, pageSize);
        return repository.findAll(specs, pageRequest);
    }

    public Page<Process> userProcesses(String title, StatusProcess statusProcess, Integer page, Integer pageSize) {
        User user = securityService.getAuthenticatedUser();
        if(user.getRole() == UserRole.USER){
            Specification<Process> specs = Specification.where(ProcessSpecs.equalCreatorId(user.getId()));
            if (title != null && !title.isEmpty()) {
                specs = specs.and(ProcessSpecs.likeTitle(title));
            }
            if (statusProcess != null) {
                specs = specs.and(ProcessSpecs.equalStatusProcess(statusProcess));
            }
            Pageable pageable = PageRequest.of(page, pageSize, Sort.by(Sort.Direction.DESC, "createdAt"));
            return repository.findAll(specs, pageable);
        }else {
            return searchProcess(title, statusProcess, page, pageSize);
        }
    }

    public void updateStatus(Long id, StatusProcess newStatus) {
        Process process = repository.findById(id)
                .orElseThrow(() ->
                        new EntityNotFoundException("Processo não encontrado com ID: " + id)
                );

        if (newStatus == StatusProcess.FINALIZADO) {
            process.getAttachments().stream()
                    .filter(att -> "PENDING".equalsIgnoreCase(att.getStatus()))
                    .findFirst()
                    .ifPresent(att -> {
                        throw new OperationNotAllowedException(
                                "Há documento pendente para assinatura: "
                                        + att.getDisplayName()
                        );
                    });
        }
        process.setStatus(newStatus);
        repository.save(process);
    }

    public Optional<Process> getById(Long id){
        return repository.findById(id);
    }

    public void delete(Process process){
        repository.delete(process);
    }

    public List<Process> getAllProcess() {
        return repository.findAll();
    }

    public List<ProcessStatusCountDTO> countProcessStatus(){
        User user = securityService.getAuthenticatedUser();
        if(user.getRole() == UserRole.USER){
            System.out.println(user.getEmail()+ " " + user.getFullName());
            return repository.countProcessStatus(user.getId());
        }else{
            return repository.countProcessStatusAdmin();
        }
    }
}
