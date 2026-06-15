package com.nitssrpi.NIT_SRPI.controller.dto;
import com.nitssrpi.NIT_SRPI.model.ApplicationField;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Set;

public record ProcessResponseDTO(Long id, String title, StatusProcess status,String statusLabel, LocalDateTime createdAt, Map<String, Object> formData, IpTypesResponseDTO ipType, List<UserSummaryDTO> authors, List<AttachmentResponseDTO> attachments, UserSummaryDTO creator, List<JustificationResponseDTO> justifications, List<ExternalAuthorResponseDTO> externalAuthors, List<ProcessRoyaltyDistributionResponseDTO> royaltyDistributions, Set<ApplicationFieldResponseDTO> applicationFields
) {
}
