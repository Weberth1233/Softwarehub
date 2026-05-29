package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.RoyaltyShareType;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record RoyaltyShareRequestDTO(
        @NotNull(message = "O tipo da cota é obrigatório")
        RoyaltyShareType type,
        Long userId,
        Long educationalInstitutionId,
        @NotNull(message = "O percentual da cota é obrigatório")
        @DecimalMin(value = "0.01", message = "O percentual deve ser maior que zero")
        @DecimalMax(value = "100.00", message = "O percentual não pode ser maior que 100")
        BigDecimal percentage
) {
}