package com.nitssrpi.NIT_SRPI.controller.dto;

public record JustificationAttachmentResponseDTO(Long id,
                                                 String fileName,
                                                 String filePath,String fileType,
                                                 Long fileSize       ) {
}
