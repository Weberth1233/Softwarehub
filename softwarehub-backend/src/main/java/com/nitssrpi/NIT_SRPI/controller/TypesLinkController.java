package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.TypesLinkRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.TypesLinkResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.TypesLinkMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.TypesLink;
import com.nitssrpi.NIT_SRPI.service.TypesLinkService;
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
@RequestMapping("types-link")
@RequiredArgsConstructor
@Tag(name = "Tipos de vínculos")
public class TypesLinkController extends GenericController<TypesLink, TypesLinkRequestDTO, TypesLinkResponseDTO, Long> {
    private final TypesLinkService service;
    private final TypesLinkMapper mapper;

    @Override
    protected GenericService<TypesLink, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<TypesLink, TypesLinkRequestDTO, TypesLinkResponseDTO> getMapper() {
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
            @RequestBody @Valid TypesLinkRequestDTO dto
    ) {
        Optional<TypesLink> optional =
                service.getById(id);
        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        TypesLink entity = optional.get();

        mapper.updateEntity(dto,entity);

        service.update(entity);
        return ResponseEntity.noContent().build();
    }

}
