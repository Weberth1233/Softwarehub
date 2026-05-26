package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.*;
import com.nitssrpi.NIT_SRPI.controller.mappers.ConsentTermMapper;
import com.nitssrpi.NIT_SRPI.model.Attachment;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.service.ConsentTermService;
import com.nitssrpi.NIT_SRPI.service.IpTypesService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("consent_term")
@RequiredArgsConstructor
@Tag(name = "Termo de Consentimento")
public class ConsentTermController implements GenericController{
    private final ConsentTermService service;
    private final IpTypesService ipTypesService;
    private final ConsentTermMapper mapper;

    @PostMapping
    @Operation(summary = "Salvar", description = "Cadastrar novo termo de consentimento")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
            @ApiResponse(responseCode = "409", description = "Conflito!"),
//            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
    })
    public ResponseEntity<Object> save(@RequestBody @Valid ConsentTermRequestDTO dto) {
        ConsentTerm consentTerm = mapper.toEntity(dto);
        service.save(consentTerm);
        URI location = generateHeaderLocation(consentTerm.getId());
        return ResponseEntity.created(location).build();
    }

    @GetMapping
    @Operation(summary = "Obter", description = "Obter todos os termos de consentimento")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<List<ConsentTermResponseDTO>> getAll(){
        List<ConsentTerm> result = service.getAll();
        List<ConsentTermResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar termo passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
            @ApiResponse(responseCode = "409", description = "Conflito!"),
    })
    public ResponseEntity<Object> updateConsentTerm
            (@RequestBody @Valid ConsentTermRequestDTO dto, @PathVariable("id") String id ) {
        var consentTermId = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<ConsentTerm> consentTermOptional = service.getById(consentTermId);
        //Se for vazio eu retorno notFound
        if(consentTermOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var consentTerm = consentTermOptional.get();
        consentTerm.setContent(dto.content());
        consentTerm.setVersion(dto.version());

        Optional<IpTypes> ipTypes  = ipTypesService.getById(dto.ipTypeId());
        ipTypes.ifPresent(consentTerm::setIpType);

        service.update(consentTerm);
        return ResponseEntity.noContent().build();
    }

    //Obter termo pelo id
    @DeleteMapping("{id}")
    @Operation(summary = "Deletar", description = "Deletar termo passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
    })
    public ResponseEntity<Object> deleteConsentTerm
    (@PathVariable("id") String id) {
        var consentTermId = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<ConsentTerm> consentTermOptional = service.getById(consentTermId);
        //Se for vazio eu retorno notFound
        if(consentTermOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(consentTermOptional.get());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("{id}")
    @Operation(summary = "Obter por id", description = "Obter dados de um termo de consentimento passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
    })
    public ResponseEntity<ConsentTermResponseDTO> getDetails
            (@PathVariable("id") String id) {
        var consentTermId = Long.parseLong(id);
        return service.getById(consentTermId).map(consentTerm -> {
            ConsentTermResponseDTO dto = mapper.toDTO(consentTerm);
            return ResponseEntity.ok(dto);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/ip_types/{id}")
    @Operation(summary = "Obter um termo de consentimento", description = "Obter um termo de consentimento passando o id do tipo de propriedade")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso no busca!"),
            @ApiResponse(responseCode = "404", description = "Item não encontrados!"),
    })
    public ResponseEntity<ConsentTermResponseDTO> getByIpTypeId(@PathVariable Long id) {
        ConsentTerm result = service.getByIpTypeId(id);
        ConsentTermResponseDTO responseDTO = mapper.toDTO(result);
        return ResponseEntity.ok(responseDTO);
    }
}
