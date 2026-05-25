package com.nitssrpi.NIT_SRPI.generic.mapper;

public interface GenericMapper<ENTITY, REQUEST_DTO, RESPONSE_DTO> {
    ENTITY toEntity(REQUEST_DTO dto);
    RESPONSE_DTO toDTO(ENTITY entity);
}
