package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermResponseDTO;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(componentModel = "spring")
//        uses = {IpTypesMapper.class})
public interface ConsentTermMapper {
//    @Autowired
//    IpTypesRepository ipTypesRepository;

//    @Mapping(target = "ipType", expression = "java( ipTypesRepository.findById(dto.ipTypeId()).orElse(null))")
    ConsentTerm toEntity(ConsentTermRequestDTO dto);
    ConsentTermResponseDTO toDTO(ConsentTerm consentTerm);
}
