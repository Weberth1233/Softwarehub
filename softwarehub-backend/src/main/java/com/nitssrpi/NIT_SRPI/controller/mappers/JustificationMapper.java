package com.nitssrpi.NIT_SRPI.controller.mappers;


import com.nitssrpi.NIT_SRPI.controller.dto.JustificationRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.JustificationResponseDTO;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.model.Justification;
import com.nitssrpi.NIT_SRPI.model.JustificationAttachment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = {
        JustificationAttachmentMapper.class
})

public interface JustificationMapper {

    Justification toEntity(JustificationRequestDTO dto);
    JustificationResponseDTO toDTO(Justification justification);
}
