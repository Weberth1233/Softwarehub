package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.model.ChangeRequestAttachment;
import com.nitssrpi.NIT_SRPI.repository.ChangeRequestAttachmentRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class ChangeRequestAttachmentService {

    @Value("${file.upload-dir}")
    private String uploadDir;

    private final ChangeRequestAttachmentRepository repository;

    public ChangeRequestAttachmentService(ChangeRequestAttachmentRepository repository) {
        this.repository = repository;
    }

    public ChangeRequestAttachment upload(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("O arquivo é obrigatório.");
        }

        try {
            Path directory = Paths.get(uploadDir, "change-requests");
            Files.createDirectories(directory);

            String originalFileName = file.getOriginalFilename();
            String extension = getFileExtension(originalFileName);
            String storedFileName = UUID.randomUUID() + extension;

            Path filePath = directory.resolve(storedFileName);

            Files.copy(
                    file.getInputStream(),
                    filePath,
                    StandardCopyOption.REPLACE_EXISTING
            );

            ChangeRequestAttachment attachment = new ChangeRequestAttachment();
            attachment.setDisplayName(originalFileName);
            attachment.setFilePath(filePath.toString());
            attachment.setContentType(file.getContentType());
            attachment.setFileSize(file.getSize());

            return repository.save(attachment);

        } catch (IOException e) {
            throw new RuntimeException("Erro ao salvar o arquivo.", e);
        }
    }

    private String getFileExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) {
            return "";
        }

        return fileName.substring(fileName.lastIndexOf("."));
    }
}
