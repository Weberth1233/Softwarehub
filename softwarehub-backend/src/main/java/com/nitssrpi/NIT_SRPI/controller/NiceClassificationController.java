//package com.nitssrpi.NIT_SRPI.controller;
//import com.nitssrpi.NIT_SRPI.controller.dto.NiceClassificationRequestDTO;
//import com.nitssrpi.NIT_SRPI.controller.dto.NiceClassificationResponseDTO;
//import com.nitssrpi.NIT_SRPI.controller.mappers.NiceClassificationMapper;
//import com.nitssrpi.NIT_SRPI.model.NiceClassification;
//import com.nitssrpi.NIT_SRPI.service.NiceClassificationService;
//import io.swagger.v3.oas.annotations.Operation;
//import io.swagger.v3.oas.annotations.responses.ApiResponse;
//import io.swagger.v3.oas.annotations.responses.ApiResponses;
//import io.swagger.v3.oas.annotations.tags.Tag;
//import jakarta.validation.Valid;
//import lombok.RequiredArgsConstructor;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import java.net.URI;
//import java.util.List;
//import java.util.Optional;
//
//@RestController
//@RequestMapping("nice-classification")
//@RequiredArgsConstructor
//@Tag(name = "Classificação de nice")
//public class NiceClassificationController implements GenericController{
//    private final NiceClassificationService service;
//    private final NiceClassificationMapper mapper;
//
//    @PostMapping
//    @Operation(summary = "Salvar", description = "Cadastrar nova Classificação de nice")
//    @ApiResponses({
//            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
//            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
//    })
//    public ResponseEntity<Object> save(@RequestBody @Valid NiceClassificationRequestDTO dto) {
//        NiceClassification niceClassification = mapper.toEntity(dto);
//        service.save(niceClassification);
//        URI location = generateHeaderLocationInteger(niceClassification.getCode());
//        return ResponseEntity.created(location).build();
//    }
//
//    @GetMapping
//    @Operation(summary = "Obter", description = "Obter todos as Classificações de nice")
//    @ApiResponses({
//            @ApiResponse(responseCode = "200", description = "Sucesso na busca!"),
//    })
//    public ResponseEntity<List<NiceClassificationResponseDTO>> all(){
//        List<NiceClassification> result = service.getAll();
//        List<NiceClassificationResponseDTO> list = result.stream().map(mapper::toDTO).toList();
//        return ResponseEntity.ok(list);
//    }
//
//    @PutMapping("{id}")
//    @Operation(summary = "Atualizar", description = "Atualizar Classificação de nice passando o ID como paramêtro")
//    @ApiResponses({
//            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
//            @ApiResponse(responseCode = "404", description = "Classificação de nice não encontrado!"),
//    })
//    public ResponseEntity<Object> update
//            (@RequestBody @Valid NiceClassificationRequestDTO dto, @PathVariable("id") String id ) {
//        var niceClassificationId = Integer.parseInt(id);
//        //Buscando na base se existe alguem com esse id
//        Optional<NiceClassification> niceClassificationOptional = service.getById(niceClassificationId);
//        //Se for vazio eu retorno notFound
//        if(niceClassificationOptional.isEmpty()){
//            return ResponseEntity.notFound().build();
//        }
//        var niceClassification = niceClassificationOptional.get();
//        niceClassification.setCode(dto.code());
//        niceClassification.setName(dto.name());
//        niceClassification.setDescription(dto.description());
//        niceClassification.setType(dto.type());
//        service.update(niceClassification);
//        return ResponseEntity.noContent().build();
//    }
//
//    @DeleteMapping("{id}")
//    @Operation(summary = "Deletar", description = "Deletar Classificação de nice passando o ID como paramêtro")
//    @ApiResponses({
//            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
//            @ApiResponse(responseCode = "404", description = "Classificação de nice não encontrado!"),
//    })
//    public ResponseEntity<Object> delete
//            (@PathVariable("id") String id) {
//        var niceClassificationId = Integer.parseInt(id);
//        //Buscando na base se existe alguem com esse id
//        Optional<NiceClassification> niceClassificationOptional = service.getById(niceClassificationId);
//        //Se for vazio eu retorno notFound
//        if(niceClassificationOptional.isEmpty()){
//            return ResponseEntity.notFound().build();
//        }
//        //Se não eu deleto
//        service.delete(niceClassificationOptional.get());
//        return ResponseEntity.noContent().build();
//    }
//
//}
