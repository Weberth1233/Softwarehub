package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.TypesLinkRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.TypesLinkResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.TypesLink;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface TypesLinkMapper extends
        GenericMapper<
                TypesLink,
                TypesLinkRequestDTO,
                TypesLinkResponseDTO> {

    void updateEntity(
            TypesLinkRequestDTO dto,
            @MappingTarget TypesLink entity
    );
}
