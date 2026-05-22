package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.*;
import com.nitssrpi.NIT_SRPI.controller.mappers.ProcessMapper;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.service.ExternalAuthorService;
import com.nitssrpi.NIT_SRPI.service.IpTypesService;
import com.nitssrpi.NIT_SRPI.service.ProcessService;
import com.nitssrpi.NIT_SRPI.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.mapstruct.control.MappingControl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;

@RestController
@RequestMapping("process")
@RequiredArgsConstructor
@Tag(name = "Processo")
public class ProcessController implements GenericController{
    private final IpTypesService ipTypesService;
    private final UserService userService;
    private final ExternalAuthorService externalAuthorService;
    private final ProcessService service;
    private final ProcessMapper mapper;

    @PostMapping
    @Operation(summary = "Salvar", description = "Cadastrar novo processo")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
    })
    public ResponseEntity<Object> save(@RequestBody @Valid ProcessRequestDTO dto) {
        Process process = mapper.toEntity(dto);
        service.save(process);
        URI location = generateHeaderLocation(process.getId());
        return ResponseEntity.created(location).build();
    }

    //Obter autor pelo id
    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar processo passando o ID")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
            @ApiResponse(responseCode = "404", description = "Processo não encontrado!"),
    })
    public ResponseEntity<Object> update
    (@RequestBody @Valid ProcessRequestDTO dto, @PathVariable("id") String id ) {
        var idIpTypes = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<Process> processOptional = service.getById(idIpTypes);
        //Se for vazio eu retorno notFound
        if(processOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        var process = processOptional.get();
        process.setTitle(dto.title());
        //Pesquisar no service de usuarios os usuarios e trazer ele pra cá novamente
        process.setFeatured(dto.isFeatured());
        process.setFormData(dto.formData());
        //Adicionando lista de users
        List<User> users = new ArrayList<User>();
        for (Long authorId : dto.authorIds()) {
            System.out.println(authorId);
            var user = userService.getUserById(authorId);
            user.ifPresent(users::add);
        }
        process.setAuthors(users);
        List<ExternalAuthor> externalAuthorList = new ArrayList<>();
        for (Long externalAuthorId : dto.externalAuthorsIds()) {
            System.out.println(externalAuthorId);
            var externalAuthor = externalAuthorService.getById(externalAuthorId);
            externalAuthor.ifPresent(externalAuthorList::add);
        }
        process.setExternalAuthors(externalAuthorList);
        //Pesquisar no service de iptypes
        Optional<IpTypes> ipTypes = ipTypesService.getById(dto.ipTypeId());
        System.out.println(ipTypes);

        ipTypes.ifPresent(process::setIpType);

        service.update(process);
        return ResponseEntity.noContent().build();
    }

    //Essa url vai ser apenas para admin
    @GetMapping
    @Operation(summary = "Pesquisar", description = "Pesquisar processo passando o titulo, status, página ou tamanho da página como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Recurso não encontrado!"),
    })
    public ResponseEntity<Page<ProcessResponseDTO>> pagedSearch( @RequestParam(value = "title", required = false) String title,
                                             @RequestParam(value = "status-process", required = false) StatusProcess statusProcess,
                                             @RequestParam(value = "page", defaultValue = "0") Integer page,
                                             @RequestParam(value = "page-size",  defaultValue = "10") Integer pageSize){
       Page<Process> resultPage = service.searchProcess(title, statusProcess, page, pageSize);
       Page<ProcessResponseDTO> result = resultPage.map(mapper::toDTO);
       return ResponseEntity.ok(result);
    }

    //Essa url vai ser apenas para usuarios comuns
    @GetMapping("/user/processes")
    @Operation(summary = "Pesquisar processo do usuário logado", description = "Pesquisar processo do usuário logado passando o titulo, status, página ou tamanho da página como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Recurso não encontrado!"),
    })
    public ResponseEntity<Page<ProcessResponseDTO>> pagedUserProcesses(
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "status-process", required = false) StatusProcess statusProcess,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(name = "page-size", defaultValue = "10") Integer pageSize
    ) {
        Page<ProcessResponseDTO> result =
                service.userProcesses(title,statusProcess, page, pageSize)
                        .map(mapper::toDTO);

        return ResponseEntity.ok(result);
    }

    @GetMapping("{id}")
    @Operation(summary = "Detalhes", description = "Exibir detalhes de um processo passando o ID como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Recurso não encontrado!"),
    })
    public ResponseEntity<ProcessResponseDTO> getDetails
    (@PathVariable("id") String id) {
        var idProcess = Long.parseLong(id);
        return service.getById(idProcess).map(process -> {
            ProcessResponseDTO dto = mapper.toDTO(process);
            return ResponseEntity.ok(dto);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/status/amount")
    @Operation(summary = "Quantidade de processo por status", description = "Exibir uma lista contendo o status e quantidade de processo com aquele status")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
    })
    public ResponseEntity<List<ProcessStatusCountDTO>> countStatus(){
        return ResponseEntity.ok(service.countProcessStatus());
    }

    @DeleteMapping("{id}")
    @Operation(summary = "Deletar", description = "Deletar processo passando o id como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletar realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Recurso não encontrado!"),
    })
    public ResponseEntity<Object> delete
            (@PathVariable("id") String id) {
        var idProcess = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<Process> processOptional = service.getById(idProcess);
        //Se for vazio eu retorno notFound
        if(processOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(processOptional.get());
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/status")
    @Operation(summary = "Atualizar status do processo", description = "Atualizar status de um processo passando o id como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizar realizado com sucesso!"),
    })
    public ResponseEntity<Void> updateStatus(
            @PathVariable Long id,
            @RequestBody StatusUpdateDTO dto) {
        service.updateStatus(id, dto.status());
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/classification")
    @Operation(summary = "Classificar classe nice do processo", description = "Atualizar status de um processo passando o id como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Classificado com sucesso!"),
    })
    public ResponseEntity<Void> classifyProcess(
            @PathVariable Long id,
            @RequestBody @Valid ProcessClassificationRequestDTO request){
        service.classifyProcess(id, request);
        return  ResponseEntity.noContent().build();
    }
}
