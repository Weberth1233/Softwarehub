package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.NiceType;
import jakarta.validation.constraints.*;

public record NiceClassificationRequestDTO (
        @NotNull(message = "O código da classe é obrigatório")
        @Min(value = 1, message = "O código deve ser entre 1 e 45")
        @Max(value = 45, message = "O código deve ser entre 1 e 45")
        Integer code,
        @NotBlank(message = "O nome é obrigatório")
        @Size(max = 150, message = "O nome deve ter no máximo 150 caracteres")
        String name,
        @NotNull(message = "O tipo é obrigatório")
        NiceType type,
        @NotBlank(message = "A descrição é obrigatória")
        @Size(max = 5000, message = "A descrição deve ter no máximo 5000 caracteres")
        String description
){
}
