package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.RoyaltyShareRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.RoyaltyShareResponseDTO;
import com.nitssrpi.NIT_SRPI.model.EducationalInstitution;
import com.nitssrpi.NIT_SRPI.model.RoyaltyShare;
import com.nitssrpi.NIT_SRPI.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface RoyaltyShareMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "distribution", ignore = true)
    @Mapping(target = "user", source = "userId")
    @Mapping(target = "educationalInstitution", source = "educationalInstitutionId")
    RoyaltyShare toEntity(RoyaltyShareRequestDTO dto);

    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "userName", source = "user.fullName")
    @Mapping(target = "educationalInstitutionId", source = "educationalInstitution.id")
    @Mapping(target = "educationalInstitutionName", source = "educationalInstitution.name")
    RoyaltyShareResponseDTO toDTO(RoyaltyShare entity);

    default User mapUser(Long id) {
        if (id == null) {
            return null;
        }

        User user = new User();
        user.setId(id);
        return user;
    }

    default EducationalInstitution mapEducationalInstitution(Long id) {
        if (id == null) {
            return null;
        }

        EducationalInstitution institution = new EducationalInstitution();
        institution.setId(id);
        return institution;
    }
}