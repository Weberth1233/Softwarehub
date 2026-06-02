package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ConsentTermAcceptanceMapper;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.ConsentTermAcceptance;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.service.ConsentTermAcceptanceService;
import com.nitssrpi.NIT_SRPI.service.ConsentTermService;
import com.nitssrpi.NIT_SRPI.service.UserService;
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
@RequestMapping("/consent-term-acceptance")
@RequiredArgsConstructor
@Tag(name = "Aceitação dos Termos de Consentimento")

public class ConsentTermAcceptanceController implements GenericController{
    private final ConsentTermAcceptanceService service;
    private final ConsentTermService consentTermService;
    private final UserService userService;
    private final ConsentTermAcceptanceMapper mapper;

    @GetMapping
    @Operation(summary = "Obter", description = "Obter todos as aceitações dos Termos de Consentimento")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
    })
    public ResponseEntity<List<ConsentTermAcceptanceResponseDTO>> getAll(){
        List<ConsentTermAcceptance> result = service.getAll();
        List<ConsentTermAcceptanceResponseDTO> list = result.stream().map(mapper::toDTO).toList();
        return ResponseEntity.ok(list);
    }

    @GetMapping("consert-term/{id}")
    @Operation(summary = "Usuário assinou o termo", description = "Obter confirmação de o termo foi assinado ou não pelo usuário logado")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Encontrado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Processo não encontrado!"),

    })
    public ResponseEntity<Boolean> consentTermWasAccepted(@PathVariable("id") Long id){
        boolean result = service.consentTermWasAccepted(id);
        return ResponseEntity.ok(result);
    }

    @PostMapping
    @Operation(summary = "Salvar", description = "Cadastrar novo Aceitação dos Termos de Consentimento")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
    })
    public ResponseEntity<Object> save(@RequestBody @Valid ConsentTermAcceptanceRequestDTO dto) {
        ConsentTermAcceptance consentTermAcceptance = mapper.toEntity(dto);
        service.save(consentTermAcceptance);
        URI location = generateHeaderLocation(consentTermAcceptance.getId());
        return ResponseEntity.created(location).build();
    }

    //Obter termo pelo id
    @DeleteMapping("{id}")
    @Operation(summary = "Deletar", description = "Deletar Aceitação dos Termos de Consentimento passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
    })
    public ResponseEntity<Object> deleteConsentTermAcceptance
    (@PathVariable("id") String id) {
        var consentTermAcceptanceId = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<ConsentTermAcceptance> consentTermAcceptanceOptional = service.getById(consentTermAcceptanceId);
        //Se for vazio eu retorno notFound
        if(consentTermAcceptanceOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(consentTermAcceptanceOptional.get());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("{id}")
    @Operation(summary = "Obter por id", description = "Obter dados de um termo de consentimento passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
    })
    public ResponseEntity<ConsentTermAcceptanceResponseDTO> getDetails
            (@PathVariable("id") String id) {
        var consentTermId = Long.parseLong(id);
        return service.getById(consentTermId).map(consentTermAcceptance -> {
            ConsentTermAcceptanceResponseDTO dto = mapper.toDTO(consentTermAcceptance);
            return ResponseEntity.ok(dto);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar termo passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Termo não encontrado!"),
    })
    public ResponseEntity<Object> updateConsentTermAcceptance
            (@RequestBody @Valid ConsentTermAcceptanceRequestDTO dto, @PathVariable("id") String id ) {
        var consentTermAcceptanceId = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<ConsentTermAcceptance> consentTermAcceptanceOptional = service.getById(consentTermAcceptanceId);
        //Se for vazio eu retorno notFound
        if(consentTermAcceptanceOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var consentTermAcceptance = consentTermAcceptanceOptional.get();
        Optional<ConsentTerm> consentTerm  = consentTermService.getById(dto.consentTermId());
        consentTerm.ifPresent(consentTermAcceptance::setConsentTerm);
        Optional<User> user  = userService.getUserById(dto.consentTermId());
        user.ifPresent(consentTermAcceptance::setUser);

        service.update(consentTermAcceptance);
        return ResponseEntity.noContent().build();
    }

}

