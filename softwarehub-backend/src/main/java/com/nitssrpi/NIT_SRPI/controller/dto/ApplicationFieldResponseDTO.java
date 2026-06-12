package com.nitssrpi.NIT_SRPI.controller.dto;
import java.time.LocalDateTime;

public record ApplicationFieldResponseDTO(
        Long id,
        String code,
        String name,
        String description,
        Long applicationAreaId,
        String applicationAreaCode,
        String applicationAreaName,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}