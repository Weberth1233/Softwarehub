package com.nitssrpi.NIT_SRPI.controller.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record RejectChangeRequestDTO(

        @NotNull(message = "O usuário responsável pela análise é obrigatório")
        Long reviewedById,

        @NotBlank(message = "O motivo da rejeição é obrigatório")
        String rejectionReason
) {
}