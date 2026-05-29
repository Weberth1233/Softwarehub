package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.Infra.security.SecurityService;
import com.nitssrpi.NIT_SRPI.controller.exceptions.OperationNotAllowedException;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessClassificationRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessStatusCountDTO;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import com.nitssrpi.NIT_SRPI.repository.NiceClassificationRepository;
import com.nitssrpi.NIT_SRPI.repository.ProcessRepository;
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

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProcessService {

    private final ProcessRepository repository;
    private final IpTypesRepository ipTypesRepository;
    private final NiceClassificationRepository niceClassificationRepository;
    private final SecurityService securityService;

    @Transactional
    public Process save(Process process) {
        User user = securityService.getAuthenticatedUser();
        System.out.println(user.getEmail()+ " " + user.getFullName());
        process.setCreator(user);

        // 1. IMPORTANTE: Buscar o tipo de PI completo no banco para ter acesso à lista de documentos (RequiredDocuments)
        IpTypes type = ipTypesRepository.findById(process.getIpType().getId())
                .orElseThrow(() -> new RuntimeException("Tipo de PI não encontrado!"));
        // Vinculamos o objeto "vivo" do banco ao processo
        process.setIpType(type);
        // 2. Agora o loop vai funcionar porque o 'type' carregou os documentos
        if (type.getRequiredDocuments() != null && !type.getRequiredDocuments().isEmpty()) {
            for (IpTypeDocument docModelo : type.getRequiredDocuments()) {
                Attachment novoAnexo = new Attachment();
                novoAnexo.setDisplayName(docModelo.getDisplayName());
                // Aqui acontece a cópia que você perguntou: igualamos os caminhos!
                novoAnexo.setTemplateFilePath(docModelo.getTemplateFilePath());
                novoAnexo.setStatus("PENDING");
                novoAnexo.setProcess(process);
                // Adicionamos na lista do processo
                process.getAttachments().add(novoAnexo);
            }
        }
        process.setStatus(StatusProcess.EM_ANDAMENTO);
        // 3. Ao salvar o processo, o JPA salvará os Attachments automaticamente
        // (se você tiver o CascadeType.ALL ou PERSIST no mapeamento da lista de attachments)
        return repository.save(process);
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

    public void update(Process process){
        if (process.getId() == null) {
            throw new IllegalArgumentException("Para atualizar é necessário que o processo esteja cadastrado!");
        }
        if(process.getExternalAuthors().isEmpty() && process.getAuthors().isEmpty()){
           throw new NullPointerException("Necessário adicionar pelo menos um membro interno ou externo ao processo!");
        }
        // 1. Buscar o processo real no banco
        Process processDb = repository.findById(process.getId())
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado"));
        // 2. Atualizar apenas os campos necessários
        processDb.setTitle(process.getTitle());

        processDb.setExternalAuthors(process.getExternalAuthors());

        //Atualizando a lista de autores também
        processDb.setAuthors(process.getAuthors());
        // Se quiser permitir alterar o tipo de PI:
        if (process.getIpType() != null) {
            IpTypes type = ipTypesRepository.findById(process.getIpType().getId())
                    .orElseThrow(() -> new RuntimeException("Tipo de PI não encontrado!"));
            processDb.setIpType(type);
        }
//        processDb.setStatus(StatusProcess.);
        repository.save(processDb);
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
        // 1. Pega o usuário logado
        User user = securityService.getAuthenticatedUser();
        //Se for admin eu retorno os processos do usuario logado caso seja admin eu retorno tudo
        if(user.getRole() == UserRole.USER){
            // 2. Começa a Specification definindo que o processo DEVE pertencer ao usuário
            // Se você não criou o método na classe ProcessSpecs, pode fazer o lambda direto aqui
            Specification<Process> specs = Specification.where(ProcessSpecs.equalCreatorId(user.getId()));
            // 3. Adiciona os filtros dinâmicos (igual ao searchProcess)
            if (title != null && !title.isEmpty()) {
                specs = specs.and(ProcessSpecs.likeTitle(title));
            }
            if (statusProcess != null) {
                specs = specs.and(ProcessSpecs.equalStatusProcess(statusProcess));
            }
            // 4. Configura a paginação
            Pageable pageable = PageRequest.of(page, pageSize, Sort.by(Sort.Direction.DESC, "createdAt"));
            // 5. Chama o findAll (que vem do JpaSpecificationExecutor)
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
