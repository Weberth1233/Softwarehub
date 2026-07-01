package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.IpTypesMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.service.IpTypesService;
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
@RequestMapping("/ip-types")
@RequiredArgsConstructor
@Tag(name = "Tipo Propriedade Intelectual")
public class IpTypesController extends GenericController<
        IpTypes,
        IpTypesRequestDTO,
        IpTypesResponseDTO,
        Long> {

    private final IpTypesService service;
    private final IpTypesMapper mapper;

    @Override
    protected GenericService<IpTypes, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<IpTypes, IpTypesRequestDTO, IpTypesResponseDTO> getMapper() {
        return mapper;
    }

    @PutMapping("{id}")
    @Operation(
            summary = "Atualizar",
            description = "Atualizar propriedade intelectual passando o ID como parâmetro"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Tipo propriedade intelectual não encontrado!"),
    })
    public ResponseEntity<Object> update(
            @PathVariable Long id,
            @RequestBody @Valid IpTypesRequestDTO dto
    ) {
        Optional<IpTypes> optional = service.getById(id);

        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        IpTypes entity = optional.get();

        mapper.updateEntity(dto, entity);

        service.update(entity);

        return ResponseEntity.noContent().build();
    }
}