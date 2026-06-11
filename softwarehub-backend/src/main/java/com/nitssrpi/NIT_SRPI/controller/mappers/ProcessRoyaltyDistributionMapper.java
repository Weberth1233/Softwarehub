package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRoyaltyDistributionRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRoyaltyDistributionResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.ProcessRoyaltyDistribution;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.RoyaltyDistributionChangeRequest;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = {
                RoyaltyShareMapper.class
        }
)
public interface ProcessRoyaltyDistributionMapper extends
        GenericMapper<
                ProcessRoyaltyDistribution,
                ProcessRoyaltyDistributionRequestDTO,
                ProcessRoyaltyDistributionResponseDTO> {

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "process", source = "processId")
    @Mapping(target = "changeRequest", source = "changeRequestId")
    @Mapping(target = "version", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    ProcessRoyaltyDistribution toEntity(ProcessRoyaltyDistributionRequestDTO dto);

    @Override
    @Mapping(target = "processId", source = "process.id")
    @Mapping(target = "changeRequestId", source = "changeRequest.id")
    ProcessRoyaltyDistributionResponseDTO toDTO(ProcessRoyaltyDistribution entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "process", source = "processId")
    @Mapping(target = "changeRequest", source = "changeRequestId")
    @Mapping(target = "version", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)

    void updateEntity(
            ProcessRoyaltyDistributionRequestDTO dto,
            @MappingTarget ProcessRoyaltyDistribution entity
    );

    default Process mapProcess(Long id) {
        if (id == null) {
            return null;
        }

        Process process = new Process();
        process.setId(id);
        return process;
    }

    default RoyaltyDistributionChangeRequest mapChangeRequest(Long id) {
        if (id == null) {
            return null;
        }

        RoyaltyDistributionChangeRequest changeRequest =
                new RoyaltyDistributionChangeRequest();

        changeRequest.setId(id);
        return changeRequest;
    }
}
