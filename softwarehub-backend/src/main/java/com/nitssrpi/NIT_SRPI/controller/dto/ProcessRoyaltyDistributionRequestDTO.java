package com.nitssrpi.NIT_SRPI.controller.dto;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.util.List;

public record ProcessRoyaltyDistributionRequestDTO(
        @NotNull(message = "O processo é obrigatório")
        Long processId,
        Long changeRequestId,
        @NotEmpty(message = "A distribuição deve possuir pelo menos uma cota")
        @Valid
        List<RoyaltyShareRequestDTO> shares
) {
}
