package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceResponseDTO;
import com.nitssrpi.NIT_SRPI.model.ConsentTermAcceptance;
import com.nitssrpi.NIT_SRPI.repository.ConsentTermRepository;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(componentModel = "spring", uses = {ConsentTermMapper.class, UserMapper.class})
public abstract class ConsentTermAcceptanceMapper {
    @Autowired
    ConsentTermRepository consentTermRepository;
//    @Autowired
//    UserRepository userRepository;

//    @Mapping(target = "user", expression = "java( userRepository.findById(dto.userId()).orElse(null))")
    @Mapping(target = "consentTerm", expression = "java( consentTermRepository.findById(dto.consentTermId()).orElse(null))")

    public abstract ConsentTermAcceptance toEntity(ConsentTermAcceptanceRequestDTO dto);
    public abstract ConsentTermAcceptanceResponseDTO toDTO(ConsentTermAcceptance consentTermAcceptance);
}
