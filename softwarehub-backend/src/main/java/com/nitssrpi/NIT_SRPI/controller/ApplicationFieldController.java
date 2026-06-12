package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationFieldRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationFieldResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ApplicationFieldMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.ApplicationField;
import com.nitssrpi.NIT_SRPI.model.ConsentTermAcceptance;
import com.nitssrpi.NIT_SRPI.service.ApplicationFieldService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/application-field")
@RequiredArgsConstructor
@Tag(name = "Campo de Aplicação")
public class ApplicationFieldController extends GenericController<ApplicationField, ApplicationFieldRequestDTO, ApplicationFieldResponseDTO, Long> {
    final ApplicationFieldService service;
    private final ApplicationFieldMapper mapper;

    @Override
    protected GenericService<ApplicationField, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<ApplicationField, ApplicationFieldRequestDTO, ApplicationFieldResponseDTO> getMapper() {
        return mapper;
    }

    @GetMapping("/search")
    @Operation(summary = "Pesquisar paginada", description = "Pesquisar campod de aplicação passando a descrição, página ou tamanho da página como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Recurso não encontrado!"),
    })
    public ResponseEntity<Page<ApplicationFieldResponseDTO>> pagedSearch(@RequestParam(value = "description", required = false) String description,
                                                                @RequestParam(value = "page", defaultValue = "0") Integer page,
                                                                @RequestParam(value = "page-size",  defaultValue = "10") Integer pageSize){
        Page<ApplicationField> resultPage = service.searchApplicationField(description, page, pageSize);
        Page<ApplicationFieldResponseDTO> result = resultPage.map(mapper::toDTO);
        return ResponseEntity.ok(result);
    }

    @GetMapping("application-area/{id}")
    @Operation(summary = "Obter", description = "Obter todos os campos de aplicação vinculados a uma area passsando o ID da area")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<List<ApplicationFieldResponseDTO>> getAllByApplicationAreaId(@PathVariable Long id){
        List<ApplicationField> result = service.findByApplicationAreaId(id);
        List<ApplicationFieldResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Item não encontrado!"),
    })
    public ResponseEntity<Object> update(
            @PathVariable Long id,
            @RequestBody @Valid ApplicationFieldRequestDTO dto
    ) {
        Optional<ApplicationField> optional =
                service.getById(id);
        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        ApplicationField entity = optional.get();

        mapper.updateEntity(dto,entity);

        service.update(entity);
        return ResponseEntity.noContent().build();
    }
}
