package com.nitssrpi.NIT_SRPI.controller.dto;
import java.time.LocalDateTime;

public record ApplicationAreaResponseDTO(

        Long id,

        String code,

        String name,

        Integer displayOrder,

        LocalDateTime createdAt,

        LocalDateTime updatedAt

) {
}