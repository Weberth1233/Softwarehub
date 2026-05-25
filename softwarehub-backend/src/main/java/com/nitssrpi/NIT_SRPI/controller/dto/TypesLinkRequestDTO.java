package com.nitssrpi.NIT_SRPI.controller.dto;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record TypesLinkRequestDTO(
        @NotBlank(message = "O nome do tipo de vínculo é obrigatório")
        @Size(
                min = 3,
                max = 255,
                message = "O nome do tipo de vínculo deve ter entre 3 e 255 caracteres"
        )
        @Pattern(
                regexp = "^[A-Za-zÀ-ÿ0-9 .,'()\\-]+$",
                message = "O nome do tipo de vínculo contém caracteres inválidos"
        )
        String name) {
}
