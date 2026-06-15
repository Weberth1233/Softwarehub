package com.nitssrpi.NIT_SRPI.controller.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import org.hibernate.validator.constraints.NotEmpty;

import java.util.List;

public record ProcessClassificationRequestDTO(

        @NotEmpty(message = "Selecione pelo menos um campo de aplicação.")
        List<@NotNull(message = "O campo de aplicação não pode ser nulo.")
        @Positive(message = "O ID do campo de aplicação deve ser maior que zero.")
                Long> applicationFields

) {
}
