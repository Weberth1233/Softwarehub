package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.model.Attachment;
import com.nitssrpi.NIT_SRPI.repository.AttachmentRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Service
public class AttachmentService {

    private final Path fileStorageLocation;
    private final AttachmentRepository attachmentRepository;
    private final ProcessService processService;

    public AttachmentService(
            @Value("${file.upload-dir}") String uploadDir,
            AttachmentRepository attachmentRepository,
            ProcessService processService
    ) {
        this.fileStorageLocation = Paths.get(uploadDir).toAbsolutePath().normalize();
        this.attachmentRepository = attachmentRepository;
        this.processService = processService;

        System.out.println("📁 Upload dir REAL: " + this.fileStorageLocation);

        try {
            Files.createDirectories(this.fileStorageLocation.resolve("templates"));
            Files.createDirectories(this.fileStorageLocation.resolve("attachments"));
        } catch (Exception ex) {
            throw new RuntimeException("Erro ao criar pastas de upload", ex);
        }
    }

    public Resource loadFile(String relativePath) {
        try {
            Path filePath = this.fileStorageLocation.resolve(relativePath).normalize();

            System.out.println("📄 Tentando abrir: " + filePath);

            Resource resource = new UrlResource(filePath.toUri());

            if (resource.exists()) {
                return resource;
            }

            throw new RuntimeException("Arquivo não encontrado: " + relativePath);

        } catch (MalformedURLException ex) {
            throw new RuntimeException("Erro no caminho do arquivo", ex);
        }
    }

    @Transactional
    public void saveSignedFile(MultipartFile file, Attachment attachment) {
        try {
            Attachment attachmentFromDb = attachmentRepository.findById(attachment.getId())
                    .orElseThrow(() -> new EntityNotFoundException("Anexo não encontrado."));

            Long processId = attachmentFromDb.getProcess().getId();

            String fileName = "attachments/proc_" + processId + "_att_" + attachmentFromDb.getId() + ".pdf";

            Path targetLocation = this.fileStorageLocation.resolve(fileName).normalize();

            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

            attachmentFromDb.setSignedFilePath(fileName);
            attachmentFromDb.setStatus("SIGNED");

            attachmentRepository.save(attachmentFromDb);

            processService.refreshStatusAfterRequirementsChange(processId);

        } catch (IOException ex) {
            throw new RuntimeException("Erro ao salvar arquivo assinado", ex);
        }
    }
}