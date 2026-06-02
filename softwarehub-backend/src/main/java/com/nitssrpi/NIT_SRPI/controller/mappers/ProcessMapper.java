package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessResponseDTO;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.*;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(componentModel = "spring", uses = {IpTypesMapper.class, UserMapper.class, NiceClassificationMapper.class,
        ProcessRoyaltyDistributionMapper.class
})

public abstract class ProcessMapper {
    @Autowired
    IpTypesRepository ipTypesRepository;
    @Autowired
    ExternalAuthorRepository externalAuthorRepository;
    @Autowired
    UserRepository userRepository;

    @Mapping(target = "ipType", expression = "java( ipTypesRepository.findById(dto.ipTypeId()).orElse(null))")
    @Mapping(target = "authors", expression = "java(userRepository.findAllById(dto.authorIds()))")
    @Mapping(target = "externalAuthors", expression = "java(externalAuthorRepository.findAllById(dto.externalAuthorsIds()))")

    public abstract Process toEntity(ProcessRequestDTO dto);
    public abstract ProcessResponseDTO toDTO(Process process);
}
