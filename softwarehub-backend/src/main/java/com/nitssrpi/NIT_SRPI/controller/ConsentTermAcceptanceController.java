package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ConsentTermAcceptanceMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.ConsentTermAcceptance;
import com.nitssrpi.NIT_SRPI.service.ConsentTermAcceptanceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;

@RestController
@RequestMapping("/consent-term-acceptance")
@RequiredArgsConstructor
@Tag(name = "Aceitação dos Termos de Consentimento")
public class ConsentTermAcceptanceController extends GenericController<
        ConsentTermAcceptance,
        ConsentTermAcceptanceRequestDTO,
        ConsentTermAcceptanceResponseDTO,
        Long> {

    private final ConsentTermAcceptanceService service;
    private final ConsentTermAcceptanceMapper mapper;

    @Override
    protected GenericService<ConsentTermAcceptance, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<
            ConsentTermAcceptance,
            ConsentTermAcceptanceRequestDTO,
            ConsentTermAcceptanceResponseDTO> getMapper() {
        return mapper;
    }

    @GetMapping("consent-term/{id}")
    @Operation(
            summary = "Usuário aceitou o termo",
            description = "Obter confirmação se o termo foi aceito ou não pelo usuário logado"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
    })
    public ResponseEntity<Boolean> consentTermWasAccepted(@PathVariable Long id) {
        boolean result = service.consentTermWasAccepted(id);
        return ResponseEntity.ok(result);
    }

    @PutMapping("{id}")
    @Operation(
            summary = "Atualizar",
            description = "Atualizar aceitação de termo passando o ID como parâmetro"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Aceitação de termo não encontrada!"),
    })
    public ResponseEntity<Object> update(
            @PathVariable Long id,
            @RequestBody @Valid ConsentTermAcceptanceRequestDTO dto
    ) {
        Optional<ConsentTermAcceptance> optional = service.getById(id);

        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        ConsentTermAcceptance entity = optional.get();

        mapper.updateEntity(dto, entity);

        service.update(entity);

        return ResponseEntity.noContent().build();
    }
}