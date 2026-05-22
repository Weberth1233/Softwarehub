package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.NiceType;

public record NiceClassificationResponseDTO(
        Integer code,
        String name,
        NiceType type,
        String description) {
}
