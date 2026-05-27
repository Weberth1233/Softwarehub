package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.UserEducationalInstitutionLinkRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserEducationalInstitutionLinkResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.EducationalInstitution;
import com.nitssrpi.NIT_SRPI.model.TypesLink;
import com.nitssrpi.NIT_SRPI.model.UserEducationalInstitutionLink;
import com.nitssrpi.NIT_SRPI.repository.EducationalInstitutionRepository;
import com.nitssrpi.NIT_SRPI.repository.TypesLinkRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(
        componentModel = "spring"
)
public abstract class UserEducationalInstitutionLinkMapper
        implements GenericMapper<
        UserEducationalInstitutionLink,
        UserEducationalInstitutionLinkRequestDTO,
        UserEducationalInstitutionLinkResponseDTO> {

    public abstract void updateEntity(
            UserEducationalInstitutionLinkRequestDTO dto,
            @MappingTarget UserEducationalInstitutionLink entity
    );

    @Override
    @Mapping(
            target = "typesLink",
            source = "typesLinkId"
    )
    @Mapping(
            target = "educationalInstitution",
            source = "educationalInstitutionId"
    )
    public abstract UserEducationalInstitutionLink toEntity(
            UserEducationalInstitutionLinkRequestDTO dto
    );

    @Override
    public abstract UserEducationalInstitutionLinkResponseDTO toDTO(
            UserEducationalInstitutionLink entity
    );

    protected TypesLink mapTypesLink(Long id){

        if(id == null){
            return null;
        }

        TypesLink typesLink = new TypesLink();
        typesLink.setId(id);

        return typesLink;
    }

    protected EducationalInstitution mapEducationalInstitution(Long id){

        if(id == null){
            return null;
        }

        EducationalInstitution educationalInstitution =
                new EducationalInstitution();

        educationalInstitution.setId(id);

        return educationalInstitution;
    }
}

