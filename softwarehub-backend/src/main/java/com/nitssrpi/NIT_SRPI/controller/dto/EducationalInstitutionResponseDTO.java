package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.InstitutionType;

import java.time.LocalDateTime;

public record EducationalInstitutionResponseDTO(Long id,
                                                String name,
                                                String cnpj,
                                                Boolean active,
                                                InstitutionType institutionType,
                                                LocalDateTime createdAt,
                                                LocalDateTime updatedAt
                                                ) {
}
