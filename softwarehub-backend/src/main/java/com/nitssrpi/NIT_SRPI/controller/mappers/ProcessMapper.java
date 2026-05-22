package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessResponseDTO;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.ExternalAuthorRepository;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import com.nitssrpi.NIT_SRPI.repository.NiceClassificationRepository;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(componentModel = "spring", uses = {IpTypesMapper.class, UserMapper.class, NiceClassificationMapper.class})
public abstract class ProcessMapper {
    @Autowired
    IpTypesRepository ipTypesRepository;
    @Autowired
    ExternalAuthorRepository externalAuthorRepository;
    @Autowired
    protected UserRepository userRepository;

    @Mapping(target = "ipType", expression = "java( ipTypesRepository.findById(dto.ipTypeId()).orElse(null))")
    @Mapping(target = "authors", expression = "java(userRepository.findAllById(dto.authorIds()))")
    @Mapping(target = "externalAuthors", expression = "java(externalAuthorRepository.findAllById(dto.externalAuthorsIds()))")

//    @Mapping(target = "creator", expression = "java(userRepository.findById(dto.creatorId()).orElse(null))")
    public abstract Process toEntity(ProcessRequestDTO dto);

    public abstract ProcessResponseDTO toDTO(Process process);
}
