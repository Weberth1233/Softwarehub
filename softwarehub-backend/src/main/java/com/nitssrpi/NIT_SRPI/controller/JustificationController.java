package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.JustificationRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.JustificationResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.JustificationMapper;
import com.nitssrpi.NIT_SRPI.model.Justification;
import com.nitssrpi.NIT_SRPI.model.JustificationAttachment;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.JustificationAttachmentRepository;
import com.nitssrpi.NIT_SRPI.service.JustificationService;
import com.nitssrpi.NIT_SRPI.service.ProcessService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.core.io.Resource;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("justification")
@RequiredArgsConstructor
@Tag(name = "Justificativa")
public class JustificationController implements  GenericController{
    private final JustificationService service;
    private final ProcessService processService;
    private final JustificationMapper mapper;
    private final JustificationAttachmentRepository attachmentRepository;

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Salvar", description = "Cadastrar nova justificativa")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
    })
    public ResponseEntity<Void> save(@ModelAttribute @Valid JustificationRequestDTO dto) {
        Justification saved = service.save(dto.processId(), dto.reason(), dto.file());
        URI location = generateHeaderLocation(saved.getId());
        return ResponseEntity.created(location).build();
    }

    @GetMapping("process/{id}")
    @Operation(summary = "Obter justificativas de um processo", description = "Obter todas as justificativas de um processo passando o ID do processo como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Encontrado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Processo não encontrado!"),

    })
    public ResponseEntity<List<JustificationResponseDTO>> allJusticationProcess(@PathVariable("id") Long id){
        List<Justification> results = service.findByProcessJustification(id);
        List<JustificationResponseDTO> list = results.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar justificativa passando o ID como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
            @ApiResponse(responseCode = "404", description = "Justificativa não encontrado!"),
    })
    public ResponseEntity<Object> updateIpTypes
            (@RequestBody @Valid JustificationRequestDTO dto, @PathVariable("id") String id ) {
        var idJustification = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<Justification> justificationOptional = service.getById(idJustification);
        //Se for vazio eu retorno notFound
        if(justificationOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var justification = justificationOptional.get();
        justification.setReason(dto.reason());

        Optional<Process> process  = processService.getById(dto.processId());
        process.ifPresent(justification::setProcess);

        service.update(justification);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("{id}")
    @Operation(summary = "Deletar", description = "Deletar justificativa passando o ID como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Justificativa não encontada!"),
    })
    public ResponseEntity<Object> deleteIpTypes
            (@PathVariable("id") String id) {
        var idJustification = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<Justification> justificationOptional = service.getById(idJustification);
        //Se for vazio eu retorno notFound
        if(justificationOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(justificationOptional.get());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/attachments/{id}/file")
    public ResponseEntity<Resource> getAttachmentFile(@PathVariable Long id) {
        JustificationAttachment attachment = attachmentRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Arquivo não encontrado!"));
        try {
            Path path = Paths.get(attachment.getFilePath()).normalize();
            Resource resource = new UrlResource(path.toUri());
            if (!resource.exists()) {
                throw new EntityNotFoundException("Arquivo não encontrado no servidor!");
            }
            String contentType = attachment.getFileType();
            if (contentType == null || contentType.equals("application/octet-stream")) {
                contentType = Files.probeContentType(path);
            }
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(
                            HttpHeaders.CONTENT_DISPOSITION,
                            "inline; filename=\"" + attachment.getFileName() + "\""
                    )
                    .body(resource);
        } catch (MalformedURLException e) {
            throw new RuntimeException("Erro ao carregar arquivo!");
        } catch (IOException e) {
            throw new RuntimeException("Erro ao identificar o tipo do arquivo!");
        }
    }
}
