package com.nitssrpi.NIT_SRPI.controller.dto;

import jakarta.validation.constraints.NotNull;

public record ApproveChangeRequestDTO(

        @NotNull(message = "O usuário responsável pela análise é obrigatório")
        Long reviewedById
) {
}