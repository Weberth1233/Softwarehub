package com.nitssrpi.NIT_SRPI.controller.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

public record RoyaltyDistributionChangeRequestRequestDTO(

        @NotNull(message = "O processo é obrigatório")
        Long processId,

        @NotNull(message = "O usuário solicitante é obrigatório")
        Long requestedById,

        @NotNull(message = "O novo percentual da universidade é obrigatório")
        @DecimalMin(value = "0.01", message = "O percentual da universidade deve ser maior que zero")
        @DecimalMax(value = "99.99", message = "O percentual da universidade deve ser menor que 100")
        BigDecimal requestedUniversityPercentage,

        @NotBlank(message = "A justificativa da alteração é obrigatória")
        String justification,

        @NotNull(message = "O anexo da justificativa é obrigatório")
        Long attachmentId
) {
}