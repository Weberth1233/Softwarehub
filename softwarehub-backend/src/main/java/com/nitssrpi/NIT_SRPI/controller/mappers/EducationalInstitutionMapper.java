package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.EducationalInstitutionRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.EducationalInstitutionResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.EducationalInstitution;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface EducationalInstitutionMapper extends
        GenericMapper<
                        EducationalInstitution,
                        EducationalInstitutionRequestDTO,
                        EducationalInstitutionResponseDTO> {

    void updateEntity(
            EducationalInstitutionRequestDTO dto,
            @MappingTarget EducationalInstitution entity
    );
}
