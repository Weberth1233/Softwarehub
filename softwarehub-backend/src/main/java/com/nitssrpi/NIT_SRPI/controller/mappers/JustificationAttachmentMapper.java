package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.JustificationAttachmentResponseDTO;
import com.nitssrpi.NIT_SRPI.model.JustificationAttachment;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface JustificationAttachmentMapper {
    JustificationAttachmentResponseDTO toDTO(JustificationAttachment attachment);
}
