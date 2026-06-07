package com.nitssrpi.NIT_SRPI.controller.dto;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public record ProcessResponseDTO(Long id, String title, StatusProcess status,String statusLabel, LocalDateTime createdAt, Map<String, Object> formData, IpTypesResponseDTO ipType, List<UserSummaryDTO> authors, List<AttachmentResponseDTO> attachments, UserSummaryDTO creator, List<JustificationResponseDTO> justifications, List<ExternalAuthorResponseDTO> externalAuthors, NiceClassificationResponseDTO niceClassification, List<ProcessRoyaltyDistributionResponseDTO> royaltyDistributions
) {
}
