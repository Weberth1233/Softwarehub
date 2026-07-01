package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ConsentTermMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.service.ConsentTermService;
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
@RequestMapping("/consent-term")
@RequiredArgsConstructor
@Tag(name = "Termo de Consentimento")
public class ConsentTermController extends GenericController<
        ConsentTerm,
        ConsentTermRequestDTO,
        ConsentTermResponseDTO,
        Long> {

    private final ConsentTermService service;
    private final ConsentTermMapper mapper;

    @Override
    protected GenericService<ConsentTerm, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<ConsentTerm, ConsentTermRequestDTO, ConsentTermResponseDTO> getMapper() {
        return mapper;
    }

    @PutMapping("{id}")
    @Operation(
            summary = "Atualizar",
            description = "Atualizar termo passando o ID como parâmetro"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
            @ApiResponse(responseCode = "409", description = "Conflito!"),
    })
    public ResponseEntity<Object> update(
            @PathVariable Long id,
            @RequestBody @Valid ConsentTermRequestDTO dto
    ) {
        Optional<ConsentTerm> optional = service.getById(id);

        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        ConsentTerm entity = optional.get();

        mapper.updateEntity(dto, entity);

        service.update(entity);

        return ResponseEntity.noContent().build();
    }

    @GetMapping("/ip-types/{id}")
    @Operation(
            summary = "Obter termo por tipo de propriedade intelectual",
            description = "Obter um termo de consentimento passando o ID do tipo de propriedade intelectual"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
    })
    public ResponseEntity<ConsentTermResponseDTO> getByIpTypeId(@PathVariable Long id) {
        ConsentTerm result = service.getByIpTypeId(id);
        ConsentTermResponseDTO responseDTO = mapper.toDTO(result);

        return ResponseEntity.ok(responseDTO);
    }
}