package com.nitssrpi.NIT_SRPI.controller.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

import java.util.List;
import java.util.Map;
@Schema(name = "Processo")
public record ProcessRequestDTO(
        @NotNull(message = "O título do processo é obrigatório")
        String title,
        Map<String, Object> formData,
        @NotNull(message = "O tipo de propriedade intelectual é obrigatório")
        Long ipTypeId,
        List<Long> authorIds,
        List<Long> externalAuthorsIds
) {
}