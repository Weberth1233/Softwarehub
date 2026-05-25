package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.UserEducationalInstitutionLinkRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserEducationalInstitutionLinkResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.UserEducationalInstitutionLink;
import com.nitssrpi.NIT_SRPI.repository.EducationalInstitutionRepository;
import com.nitssrpi.NIT_SRPI.repository.TypesLinkRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(
        componentModel = "spring",
        uses = {
                TypesLinkMapper.class,
                EducationalInstitutionMapper.class
        }
)
public abstract class UserEducationalInstitutionLinkMapper
        implements GenericMapper<
        UserEducationalInstitutionLink,
        UserEducationalInstitutionLinkRequestDTO,
        UserEducationalInstitutionLinkResponseDTO> {

    @Autowired
    protected TypesLinkRepository typesLinkRepository;

    @Autowired
    protected EducationalInstitutionRepository educationalInstitutionRepository;

    public abstract void updateEntity(
            UserEducationalInstitutionLinkRequestDTO dto,
            @MappingTarget UserEducationalInstitutionLink entity
    );

    @Override
    @Mapping(
            target = "typesLink",
            expression = "java(typesLinkRepository.findById(dto.typesLinkId()).orElse(null))"
    )
    @Mapping(
            target = "educationalInstitution",
            expression = "java(educationalInstitutionRepository.findById(dto.educationalInstitutionId()).orElse(null))"
    )
    public abstract UserEducationalInstitutionLink toEntity(
            UserEducationalInstitutionLinkRequestDTO dto
    );

    @Override
    public abstract UserEducationalInstitutionLinkResponseDTO toDTO(
            UserEducationalInstitutionLink entity
    );


}
