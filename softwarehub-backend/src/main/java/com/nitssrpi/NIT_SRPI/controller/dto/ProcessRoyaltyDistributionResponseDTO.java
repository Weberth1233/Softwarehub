package com.nitssrpi.NIT_SRPI.controller.dto;
import com.nitssrpi.NIT_SRPI.model.RoyaltyDistributionStatus;
import java.time.LocalDateTime;
import java.util.List;

public record ProcessRoyaltyDistributionResponseDTO(
        Long id,
        Long processId,
        Integer version,
        RoyaltyDistributionStatus status,
        Long changeRequestId,
        LocalDateTime createdAt,
        LocalDateTime updatedAt,
        List<RoyaltyShareResponseDTO> shares
) {
}
