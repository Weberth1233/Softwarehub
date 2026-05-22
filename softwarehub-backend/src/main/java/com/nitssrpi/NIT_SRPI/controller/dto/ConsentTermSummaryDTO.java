package com.nitssrpi.NIT_SRPI.controller.dto;

import java.time.LocalDateTime;

public record ConsentTermSummaryDTO(Long id, String content, LocalDateTime createdAt, Integer version) {
}
