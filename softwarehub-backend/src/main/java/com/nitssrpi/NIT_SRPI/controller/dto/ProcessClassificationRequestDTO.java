package com.nitssrpi.NIT_SRPI.controller.dto;

import jakarta.validation.constraints.NotNull;

public record ProcessClassificationRequestDTO(
        @NotNull(message = "A classe NICE é obrigatória")
        Integer niceClassCode
) {
}
