//package com.nitssrpi.NIT_SRPI.controller;
//import com.nitssrpi.NIT_SRPI.controller.dto.TypesLinkRequestDTO;
//import com.nitssrpi.NIT_SRPI.controller.dto.UserEducationalInstitutionLinkRequestDTO;
//import com.nitssrpi.NIT_SRPI.controller.dto.UserEducationalInstitutionLinkResponseDTO;
//import com.nitssrpi.NIT_SRPI.controller.mappers.UserEducationalInstitutionLinkMapper;
//import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
//import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
//import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
//import com.nitssrpi.NIT_SRPI.model.TypesLink;
//import com.nitssrpi.NIT_SRPI.model.UserEducationalInstitutionLink;
//import com.nitssrpi.NIT_SRPI.service.UserEducationalInstitutionLinkService;
//import io.swagger.v3.oas.annotations.Operation;
//import io.swagger.v3.oas.annotations.responses.ApiResponse;
//import io.swagger.v3.oas.annotations.responses.ApiResponses;
//import io.swagger.v3.oas.annotations.tags.Tag;
//import jakarta.validation.Valid;
//import lombok.RequiredArgsConstructor;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.Optional;
//
//@RestController
//@RequestMapping("user_educational_institution_link")
//@RequiredArgsConstructor
//@Tag(name = "Vínculo da instituição educacional do usuário")
//public class UserEducationalInstitutionLinkController extends GenericController<UserEducationalInstitutionLink, UserEducationalInstitutionLinkRequestDTO, UserEducationalInstitutionLinkResponseDTO, Long> {
//    private final UserEducationalInstitutionLinkService service;
//    private final UserEducationalInstitutionLinkMapper mapper;
//
//    @Override
//    protected GenericService<UserEducationalInstitutionLink, Long> getService() {
//        return service;
//    }
//
//    @Override
//    protected GenericMapper<UserEducationalInstitutionLink, UserEducationalInstitutionLinkRequestDTO, UserEducationalInstitutionLinkResponseDTO> getMapper() {
//        return mapper;
//    }
//
//    @PutMapping("{id}")
//    @Operation(summary = "Atualizar", description = "Atualizar passando o ID como paramêtro")
//    @ApiResponses({
//            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
//            @ApiResponse(responseCode = "404", description = "Item não encontrado!"),
//    })
//    public ResponseEntity<Object> update(
//            @PathVariable Long id,
//            @RequestBody @Valid UserEducationalInstitutionLinkRequestDTO dto
//    ) {
//        Optional<UserEducationalInstitutionLink> optional =
//                service.getById(id);
//        if (optional.isEmpty()) {
//            return ResponseEntity.notFound().build();
//        }
//        UserEducationalInstitutionLink entity = optional.get();
//
//        mapper.updateEntity(dto,entity);
//
//        service.update(entity);
//        return ResponseEntity.noContent().build();
//    }
//}
