package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.EducationalInstitutionRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.EducationalInstitutionResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.EducationalInstitutionMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.EducationalInstitution;
import com.nitssrpi.NIT_SRPI.service.EducationalInstitutionService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;

@RestController
@RequestMapping("educational_institution")
@RequiredArgsConstructor
@Tag(name = "Instituição Educacional")
public class EducationalInstitutionController extends GenericController<EducationalInstitution, EducationalInstitutionRequestDTO, EducationalInstitutionResponseDTO, Long> {
    private final EducationalInstitutionService service;
    private final EducationalInstitutionMapper mapper;

    @Override
    protected GenericService<EducationalInstitution, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<EducationalInstitution, EducationalInstitutionRequestDTO, EducationalInstitutionResponseDTO> getMapper() {
        return mapper;
    }

    @PutMapping("{id}")
    public ResponseEntity<Object> update(
            @PathVariable Long id,
            @RequestBody @Valid EducationalInstitutionRequestDTO dto
    ) {
        Optional<EducationalInstitution> optional =
                service.getById(id);
        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        EducationalInstitution entity = optional.get();

        entity.setName(dto.name());
        entity.setCnpj(dto.cnpj());
        entity.setInstitutionType(dto.institutionType());

        service.update(entity);
        return ResponseEntity.noContent().build();
    }
}
