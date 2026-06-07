package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.StatusProcess;

public interface ProcessStatusCountDTO {

     StatusProcess getStatus();

     Long getAmount();

     default String getStatusLabel() {
          return getStatus() != null ? getStatus().getLabel() : null;
     }
}