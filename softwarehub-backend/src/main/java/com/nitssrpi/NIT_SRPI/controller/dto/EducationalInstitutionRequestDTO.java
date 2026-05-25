package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.InstitutionType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import org.hibernate.validator.constraints.br.CNPJ;

public record EducationalInstitutionRequestDTO(
        @NotBlank(message = "O nome da instituição é obrigatório")
        @Size(
                min = 3,
                max = 255,
                message = "O nome da instituição deve ter entre 3 e 255 caracteres"
        )
        @Pattern(
                regexp = "^[A-Za-zÀ-ÿ0-9 .,'()\\-]+$",
                message = "O nome da instituição contém caracteres inválidos"
        )
        String name,
        @NotBlank(message = "O CNPJ é obrigatório")
        @CNPJ(message = "CNPJ inválido")
        String cnpj,
        @NotNull(message = "O tipo da instituição é obrigatório")
        InstitutionType institutionType) {
}
