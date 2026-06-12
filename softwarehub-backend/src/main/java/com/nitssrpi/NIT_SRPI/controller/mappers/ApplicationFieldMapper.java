package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationFieldRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationFieldResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.ApplicationArea;
import com.nitssrpi.NIT_SRPI.model.ApplicationField;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ApplicationFieldMapper extends
        GenericMapper<
                ApplicationField,
                ApplicationFieldRequestDTO,
                ApplicationFieldResponseDTO> {

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "applicationArea", source = "applicationAreaId")
    @Mapping(target = "processes", ignore = true)
    @Mapping(target = "active", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    ApplicationField toEntity(ApplicationFieldRequestDTO dto);

    @Override
    @Mapping(target = "applicationAreaId", source = "applicationArea.id")
    @Mapping(target = "applicationAreaCode", source = "applicationArea.code")
    @Mapping(target = "applicationAreaName", source = "applicationArea.name")
    ApplicationFieldResponseDTO toDTO(ApplicationField entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "applicationArea", source = "applicationAreaId")
    @Mapping(target = "processes", ignore = true)
    @Mapping(target = "active", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    void updateEntity(
            ApplicationFieldRequestDTO dto,
            @MappingTarget ApplicationField entity
    );

    default ApplicationArea mapApplicationArea(Long id) {
        if (id == null) {
            return null;
        }

        ApplicationArea applicationArea = new ApplicationArea();
        applicationArea.setId(id);
        return applicationArea;
    }
}
