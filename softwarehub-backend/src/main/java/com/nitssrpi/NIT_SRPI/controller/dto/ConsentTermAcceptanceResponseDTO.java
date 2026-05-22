package com.nitssrpi.NIT_SRPI.controller.dto;
import java.time.LocalDateTime;

public record ConsentTermAcceptanceResponseDTO(
        Long id,
        ConsentTermSummaryDTO consentTerm,
        UserSummaryDTO user,
        LocalDateTime acceptedAt
) {
}
