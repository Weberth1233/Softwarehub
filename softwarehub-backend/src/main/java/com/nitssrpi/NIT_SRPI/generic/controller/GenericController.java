package com.nitssrpi.NIT_SRPI.generic.controller;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import java.net.URI;
import java.util.List;
import java.util.Optional;

public abstract class GenericController<
        ENTITY,
        REQUEST_DTO,
        RESPONSE_DTO,
        ID> {

    protected abstract GenericService<ENTITY, ID> getService();

    protected abstract GenericMapper<
                ENTITY,
                REQUEST_DTO,
                RESPONSE_DTO> getMapper();

    @PostMapping
    @Operation(summary = "Salvar", description = "Novo cadastro")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
    })
    public ResponseEntity<Object> save(
            @RequestBody @Valid REQUEST_DTO dto
    ) {

        ENTITY entity = getMapper().toEntity(dto);

        ENTITY saved = getService().save(entity);

        URI location = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(getService().getEntityId(saved))
                .toUri();

        return ResponseEntity.created(location).build();
    }

    @GetMapping
    @Operation(summary = "Obter", description = "Obter todos os itens")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<List<RESPONSE_DTO>> getAll() {

        List<ENTITY> result = getService().getAll();

        List<RESPONSE_DTO> response =
                result.stream()
                        .map(getMapper()::toDTO)
                        .toList();

        return ResponseEntity.ok(response);
    }

    @GetMapping("{id}")
    @Operation(summary = "Obter um item", description = "Obter um item especifico passando o ID como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<RESPONSE_DTO> getById(
            @PathVariable ID id
    ) {

        Optional<ENTITY> entity = getService().getById(id);

        if (entity.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        RESPONSE_DTO response =
                getMapper().toDTO(entity.get());

        return ResponseEntity.ok(response);
    }

    @DeleteMapping("{id}")
    @Operation(summary = "Deletar", description = "Deletar item passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Item não encontrado!"),
    })
    public ResponseEntity<Object> delete(
            @PathVariable ID id
    ) {

        Optional<ENTITY> entity =
                getService().getById(id);

        if (entity.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        getService().delete(entity.get());

        return ResponseEntity.noContent().build();
    }
}
