package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.NiceClassificationRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.NiceClassificationResponseDTO;
import com.nitssrpi.NIT_SRPI.model.NiceClassification;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface NiceClassificationMapper {
    NiceClassification toEntity(NiceClassificationRequestDTO dto);
    NiceClassificationResponseDTO toDTO(NiceClassification niceClassification);
}
