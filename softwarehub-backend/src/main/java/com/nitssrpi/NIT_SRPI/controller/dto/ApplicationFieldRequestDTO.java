package com.nitssrpi.NIT_SRPI.controller.dto;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record ApplicationFieldRequestDTO(
        @NotBlank(message = "O código do campo de aplicação é obrigatório.")
        @Size(max = 10, message = "O código do campo de aplicação deve ter no máximo 10 caracteres.")
        String code,

        @NotBlank(message = "O nome do campo de aplicação é obrigatório.")
        @Size(max = 150, message = "O nome do campo de aplicação deve ter no máximo 150 caracteres.")
        String name,

        String description,

        @NotNull(message = "A área de aplicação é obrigatória.")
        Long applicationAreaId

) {
}