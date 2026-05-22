package com.nitssrpi.NIT_SRPI.controller.dto;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record ConsentTermAcceptanceRequestDTO(
        @NotNull(message = "O termo de consentimento é obrigatório")
        @Positive(message = "O ID do termo deve ser maior que zero")
        Long consentTermId
//        @NotNull(message = "O usuário é obrigatório")
//        @Positive(message = "O ID do usuário deve ser maior que zero")
//        Long userId
        ) {
}
