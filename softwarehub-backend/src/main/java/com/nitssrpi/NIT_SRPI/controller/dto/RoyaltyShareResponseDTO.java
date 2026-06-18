package com.nitssrpi.NIT_SRPI.controller.dto;
import com.nitssrpi.NIT_SRPI.model.RoyaltyShareType;
import java.math.BigDecimal;

public record RoyaltyShareResponseDTO(
        Long id,
        RoyaltyShareType type,
        Long userId,
        String userName,
        Long externalAuthorId,
        String externalAuthorName,
        Long educationalInstitutionId,
        String educationalInstitutionName,
        BigDecimal percentage
) {
}
