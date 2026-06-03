package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.UserEducationalInstitutionLinkRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserUpdateDTO;
import com.nitssrpi.NIT_SRPI.model.EducationalInstitution;
import com.nitssrpi.NIT_SRPI.model.TypesLink;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.model.UserEducationalInstitutionLink;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserUpdateMapper {

    User toEntity(UserUpdateDTO dto);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "educationalInstitution", source = "educationalInstitutionId")
    @Mapping(target = "typesLink", source = "typesLinkId")
    UserEducationalInstitutionLink toEntity(UserEducationalInstitutionLinkRequestDTO dto);

    default EducationalInstitution mapEducationalInstitution(Long id) {
        if (id == null) {
            return null;
        }

        EducationalInstitution educationalInstitution = new EducationalInstitution();
        educationalInstitution.setId(id);
        return educationalInstitution;
    }

    default TypesLink mapTypesLink(Long id) {
        if (id == null) {
            return null;
        }

        TypesLink typesLink = new TypesLink();
        typesLink.setId(id);
        return typesLink;
    }
}