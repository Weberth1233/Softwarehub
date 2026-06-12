package com.nitssrpi.NIT_SRPI.controller.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ApplicationAreaRequestDTO(
        @NotBlank(message = "O código da área é obrigatório.")
        @Size(max = 10, message = "O código da área deve ter no máximo 10 caracteres.")
        String code,
        @NotBlank(message = "O nome da área é obrigatório.")
        @Size(max = 120, message = "O nome da área deve ter no máximo 120 caracteres.")
        String name) {
}
