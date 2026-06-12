package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.IpTypesMapper;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.service.IpTypesService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;
import java.util.Optional;
//Mandando todas as atualizações do codigo para branch develop
@RestController
@RequestMapping("ip_types")
@RequiredArgsConstructor
@Tag(name = "Tipo Propriedade Intelectual")
public class IpTypesController implements GenericController{
    private final IpTypesService service;
    private final IpTypesMapper mapper;

    @PostMapping
    @Operation(summary = "Salvar", description = "Cadastrar nova propriedade intelectual")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
    })
    public ResponseEntity<Object> save(@RequestBody @Valid IpTypesRequestDTO dto) {
        IpTypes ipTypes = mapper.toEntity(dto);
        service.save(ipTypes);
        URI location = generateHeaderLocation(ipTypes.getId());
        return ResponseEntity.created(location).build();
    }

    @GetMapping
    @Operation(summary = "Obter", description = "Obter todos as propriedades intelectuais")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<List<IpTypesResponseDTO>> allTypesOfProperty(){
        List<IpTypes> result = service.allTypesOfProperty();
        List<IpTypesResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar propriedade intelectual passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Tipo propriedade intelectual não encontrado!"),
    })
    public ResponseEntity<Object> updateIpTypes
    (@RequestBody @Valid IpTypesRequestDTO dto, @PathVariable("id") String id ) {
        var idIpTypes = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<IpTypes> ipTypesOptional = service.getById(idIpTypes);
        //Se for vazio eu retorno notFound
        if(ipTypesOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var ipTypes = ipTypesOptional.get();
        ipTypes.setName(dto.name());
        ipTypes.setFormStructure(dto.formStructure());
        service.update(ipTypes);
        return ResponseEntity.noContent().build();
    }

    //Obter autor pelo id
    @GetMapping("{id}")
    @Operation(summary = "Obter por id", description = "Obter dados de um propriedade intelectual passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
            @ApiResponse(responseCode = "404", description = "Tipo propriedade intelectual não encontrado!"),
    })
    public ResponseEntity<IpTypesResponseDTO> getDetails
            (@PathVariable("id") String id) {

        var idIpTypes = Long.parseLong(id);

        return service.getById(idIpTypes).map(ipTypes -> {
            IpTypesResponseDTO dto = mapper.toDTO(ipTypes);
            return ResponseEntity.ok(dto);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    //Obter autor pelo id
    @DeleteMapping("{id}")
    @Operation(summary = "Deletar", description = "Deletar propriedade intelectual passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Tipo propriedade intelectual não encontrado!"),
    })
    public ResponseEntity<Object> deleteIpTypes
    (@PathVariable("id") String id) {
        var idIpTypes = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<IpTypes> ipTypesOptional = service.getById(idIpTypes);
        //Se for vazio eu retorno notFound
        if(ipTypesOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(ipTypesOptional.get());
        return ResponseEntity.noContent().build();
    }
}
