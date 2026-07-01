package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermAcceptanceResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.ConsentTermAcceptance;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(
        componentModel = "spring",
        uses = {
                ConsentTermMapper.class,
                UserMapper.class
        }
)
public interface ConsentTermAcceptanceMapper extends GenericMapper<
        ConsentTermAcceptance,
        ConsentTermAcceptanceRequestDTO,
        ConsentTermAcceptanceResponseDTO> {

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "consentTerm", source = "consentTermId")
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "acceptedAt", ignore = true)
    ConsentTermAcceptance toEntity(ConsentTermAcceptanceRequestDTO dto);

    @Override
    ConsentTermAcceptanceResponseDTO toDTO(ConsentTermAcceptance entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "consentTerm", source = "consentTermId")
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "acceptedAt", ignore = true)
    void updateEntity(
            ConsentTermAcceptanceRequestDTO dto,
            @MappingTarget ConsentTermAcceptance entity
    );

    default ConsentTerm mapConsentTerm(Long id) {
        if (id == null) {
            return null;
        }

        ConsentTerm consentTerm = new ConsentTerm();
        consentTerm.setId(id);
        return consentTerm;
    }
}