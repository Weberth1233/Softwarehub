package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.ChangeRequestStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record RoyaltyDistributionChangeRequestResponseDTO(

        Long id,

        Long processId,
        String processTitle,

        Long requestedById,
        String requestedByName,

        BigDecimal currentUniversityPercentage,
        BigDecimal requestedUniversityPercentage,

        String justification,

        Long attachmentId,
        String attachmentDisplayName,
        String attachmentFilePath,

        ChangeRequestStatus status,

        Long reviewedById,
        String reviewedByName,
        LocalDateTime reviewedAt,

        String rejectionReason,

        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}