package com.nitssrpi.NIT_SRPI.controller.dto;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record ConsentTermRequestDTO(
        @NotBlank(message = "O conteúdo do termo é obrigatório")
        @Size(
                min = 10,
                max = 10000,
                message = "O conteúdo do termo deve ter entre 10 e 10000 caracteres"
        )
        String content,
        @NotNull(message = "A versão do termo é obrigatória")
        @Positive(message = "A versão deve ser maior que zero")
        Integer version,
        @NotNull(message = "O tipo de propriedade intelectual é obrigatório")
        Long ipTypeId
) {
}
