package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.AttachmentResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.AttachmentMapper;
import com.nitssrpi.NIT_SRPI.model.Attachment;
import com.nitssrpi.NIT_SRPI.repository.AttachmentRepository;
import com.nitssrpi.NIT_SRPI.service.AttachmentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/attachments")
@RequiredArgsConstructor
@Tag(name = "Documentação")
public class AttachmentController {
    private final AttachmentService attachmentService;
    private final AttachmentMapper mapper;
    private final AttachmentRepository attachmentRepository;

    @GetMapping
    @Operation(summary = "Obter", description = "Obter todos os documentos")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<List<AttachmentResponseDTO>> getAllAttachments() {
        List<Attachment> result = attachmentRepository.findAll();
        List<AttachmentResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @GetMapping("/download/template/{id}")
    @Operation(summary = "Download template", description = "Fazer download de template passando o ID do documento como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso no download!"),
    })
    public ResponseEntity<Resource> downloadTemplate(@PathVariable Long id){
        Attachment att = attachmentRepository.findById(id).orElseThrow();
        // Busca sempre o caminho do template
        Resource resource = attachmentService.loadFile(att.getTemplateFilePath());

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"MODELO_" + att.getDisplayName() + ".pdf\"")
                .body(resource);
    }

    @GetMapping("/download/signed/{id}")
    @Operation(summary = "Download de documento assinado", description = "Fazer download do documento assinado passando o ID do documento como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso no download!"),
    })
    public ResponseEntity<Resource> downloadSigned(@PathVariable Long id) {
        Attachment att = attachmentRepository.findById(id).orElseThrow();

        if (att.getSignedFilePath() == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        // Busca o caminho do arquivo assinado
        Resource resource = attachmentService.loadFile(att.getSignedFilePath());

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ASSINADO_" + att.getDisplayName() + ".pdf\"")
                .body(resource);
    }

    @PostMapping("/upload/{id}")
    @Operation(summary = "Fazer upload de documento", description = "Fazer upload do documento assinado")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso no upload!"),
    })
    public ResponseEntity<String> upload(@PathVariable Long id, @RequestParam("file") MultipartFile file) {
        Attachment att = attachmentRepository.findById(id).orElseThrow();
        attachmentService.saveSignedFile(file, att);
        attachmentRepository.save(att);
        return ResponseEntity.ok("Enviado com sucesso!");
    }

    //teste backend
    @GetMapping("/process/{id}")
    @Operation(summary = "Obter documentos de um processo", description = "Obter documentos de um processo passando o id do processo")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso no busca!"),
            @ApiResponse(responseCode = "404", description = "Docuemtos não encontrados!"),

    })
    public ResponseEntity<List<AttachmentResponseDTO>> getAllAttachmentsIpType(@PathVariable Long id) {
        List<Attachment> result = attachmentRepository.findByProcessId(id);
        List<AttachmentResponseDTO> list = result.stream().map(mapper::toDTO).toList();

        return ResponseEntity.ok(list);
    }
}
