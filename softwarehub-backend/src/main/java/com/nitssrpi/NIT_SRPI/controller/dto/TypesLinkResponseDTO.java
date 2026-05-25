package com.nitssrpi.NIT_SRPI.controller.dto;

import java.time.LocalDateTime;

public record TypesLinkResponseDTO(Long id, String name, LocalDateTime createdAt, LocalDateTime updatedAt) {
}
