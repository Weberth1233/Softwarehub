package com.nitssrpi.NIT_SRPI.controller.dto;
import java.time.LocalDateTime;

public record UserEducationalInstitutionLinkResponseDTO(Long id, EducationalInstitutionResponseDTO educationalInstitution, TypesLinkResponseDTO typesLink, LocalDateTime createdAt, LocalDateTime updatedAt) {
}
