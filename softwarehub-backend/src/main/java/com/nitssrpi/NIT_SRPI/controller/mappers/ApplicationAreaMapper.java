package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationAreaRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationAreaResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.ApplicationArea;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ApplicationAreaMapper extends
        GenericMapper<
                ApplicationArea,
                ApplicationAreaRequestDTO,
                ApplicationAreaResponseDTO> {

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    ApplicationArea toEntity(ApplicationAreaRequestDTO dto);

    @Override
    ApplicationAreaResponseDTO toDTO(ApplicationArea entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    void updateEntity(
            ApplicationAreaRequestDTO dto,
            @MappingTarget ApplicationArea entity
    );
}