package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationAreaRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationAreaResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ApplicationAreaMapper;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.ApplicationArea;
import com.nitssrpi.NIT_SRPI.service.ApplicationAreaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import java.util.Optional;

@RestController
@RequestMapping("/application-area")
@RequiredArgsConstructor
@Tag(name = "Áreas de aplicação")
public class ApplicationAreaController extends GenericController<ApplicationArea, ApplicationAreaRequestDTO, ApplicationAreaResponseDTO, Long> {
    final ApplicationAreaService service;
    private final ApplicationAreaMapper mapper;

    @Override
    protected GenericService<ApplicationArea, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<ApplicationArea, ApplicationAreaRequestDTO, ApplicationAreaResponseDTO> getMapper() {
        return mapper;
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Item não encontrado!"),
    })
    public ResponseEntity<Object> update(
            @PathVariable Long id,
            @RequestBody @Valid ApplicationAreaRequestDTO dto
    ) {
        Optional<ApplicationArea> optional =
                service.getById(id);
        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        ApplicationArea entity = optional.get();

        mapper.updateEntity(dto,entity);

        service.update(entity);
        return ResponseEntity.noContent().build();
    }
}

