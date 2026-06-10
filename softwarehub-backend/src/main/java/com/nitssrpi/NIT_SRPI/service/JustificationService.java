package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.JustificationRepository;
import com.nitssrpi.NIT_SRPI.repository.ProcessRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class JustificationService {

    private final JustificationRepository repository;
    private final ProcessRepository processRepository;

    public Justification save(Long processId, String reason, MultipartFile file) {
        Process process = processRepository.findById(processId)
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado"));
        process.setStatus(StatusProcess.CORRECAO);
        Justification justification = new Justification();
        justification.setReason(reason);
        justification.setProcess(process);

        if(file != null && !file.isEmpty()){
            JustificationAttachment attachment = new JustificationAttachment();
            String fileName = file.getOriginalFilename();
            String filePath = saveFile(file);

            attachment.setFileName(fileName);
            attachment.setFilePath(filePath);
            attachment.setFileType(file.getContentType());
            attachment.setFileSize(file.getSize());
            //Criando o relacionamento
            attachment.setJustification(justification);
            justification.setAttachment(attachment);
        }
        return repository.save(justification);
    }

    private String saveFile(MultipartFile file) {
        try {
            String uploadDir = "uploads/justifications/";

            File directory = new File(uploadDir);

            if (!directory.exists()) {
                directory.mkdirs();
            }

            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            Path filePath = Paths.get(uploadDir + fileName);

            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            return filePath.toString();

        } catch (IOException e) {
            throw new RuntimeException("Erro ao salvar arquivo da justificativa!");
        }
    }

    public void update(Justification justification){
        if(justification.getId() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que a justificativa esteja cadastrado!");
        }
        repository.save(justification);
    }

    public List<Justification> findByProcessJustification(Long idProcess){
            return repository.findByProcessIdOrderByCreatedAtDesc(idProcess);
    }

    public Optional<Justification> getById(Long id){
        return repository.findById(id);
    }

    public void delete(Justification justification){
        repository.delete(justification);
    }
}

