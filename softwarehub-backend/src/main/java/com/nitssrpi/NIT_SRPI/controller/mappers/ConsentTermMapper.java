package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface ConsentTermMapper extends GenericMapper<
        ConsentTerm,
        ConsentTermRequestDTO,
        ConsentTermResponseDTO> {

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "ipType", source = "ipTypeId")
    @Mapping(target = "createdAt", ignore = true)
    ConsentTerm toEntity(ConsentTermRequestDTO dto);

    @Override
    ConsentTermResponseDTO toDTO(ConsentTerm entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "ipType", source = "ipTypeId")
    @Mapping(target = "createdAt", ignore = true)
    void updateEntity(
            ConsentTermRequestDTO dto,
            @MappingTarget ConsentTerm entity
    );

    default IpTypes mapIpTypes(Long id) {
        if (id == null) {
            return null;
        }

        IpTypes ipType = new IpTypes();
        ipType.setId(id);
        return ipType;
    }
}