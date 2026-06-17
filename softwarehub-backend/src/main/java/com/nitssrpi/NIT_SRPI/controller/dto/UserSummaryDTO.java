package com.nitssrpi.NIT_SRPI.controller.dto;
import java.time.LocalDate;
import java.util.List;

public record UserSummaryDTO(Long id, String email,
                             String phoneNumber,
                             LocalDate birthDate, String profession, String fullName, List<UserEducationalInstitutionLinkResponseDTO> userEducationalInstitutionLinks) {
}
