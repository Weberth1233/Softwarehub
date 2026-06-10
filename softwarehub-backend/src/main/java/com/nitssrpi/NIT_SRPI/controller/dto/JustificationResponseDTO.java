package com.nitssrpi.NIT_SRPI.controller.dto;

import java.time.LocalDateTime;

public record JustificationResponseDTO(Long id,
                                       String reason,
                                       LocalDateTime createdAt,
                                       JustificationAttachmentResponseDTO attachment) {
}