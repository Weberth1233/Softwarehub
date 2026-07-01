package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.IpTypesResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface IpTypesMapper extends GenericMapper<
        IpTypes,
        IpTypesRequestDTO,
        IpTypesResponseDTO> {

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "requiredDocuments", ignore = true)
    @Mapping(target = "consentTerm", ignore = true)
    IpTypes toEntity(IpTypesRequestDTO dto);

    @Override
    IpTypesResponseDTO toDTO(IpTypes entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "requiredDocuments", ignore = true)
    @Mapping(target = "consentTerm", ignore = true)
    void updateEntity(
            IpTypesRequestDTO dto,
            @MappingTarget IpTypes entity
    );
}