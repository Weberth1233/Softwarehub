package com.nitssrpi.NIT_SRPI.controller.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.web.multipart.MultipartFile;

@Schema(name = "Justificativa")
public record JustificationRequestDTO(
        @NotNull(message = "Processo é obrigatório")
        Long processId,

        @NotBlank(message = "Justificativa é obrigatória")
        String reason,

        MultipartFile file
) {
}