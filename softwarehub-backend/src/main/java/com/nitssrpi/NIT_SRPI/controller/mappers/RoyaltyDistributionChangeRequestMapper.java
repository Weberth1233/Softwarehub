package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.RoyaltyDistributionChangeRequestRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.RoyaltyDistributionChangeRequestResponseDTO;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.model.ChangeRequestAttachment;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.RoyaltyDistributionChangeRequest;
import com.nitssrpi.NIT_SRPI.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface RoyaltyDistributionChangeRequestMapper extends
        GenericMapper<
                RoyaltyDistributionChangeRequest,
                RoyaltyDistributionChangeRequestRequestDTO,
                RoyaltyDistributionChangeRequestResponseDTO> {

    @Override
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "process", source = "processId")
    @Mapping(target = "requestedBy", source = "requestedById")
    @Mapping(target = "attachment", source = "attachmentId")
    @Mapping(target = "currentUniversityPercentage", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "reviewedBy", ignore = true)
    @Mapping(target = "reviewedAt", ignore = true)
    @Mapping(target = "rejectionReason", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    RoyaltyDistributionChangeRequest toEntity(
            RoyaltyDistributionChangeRequestRequestDTO dto
    );

    @Override
    @Mapping(target = "processId", source = "process.id")
    @Mapping(target = "processTitle", source = "process.title")
    @Mapping(target = "requestedById", source = "requestedBy.id")
    @Mapping(target = "requestedByName", source = "requestedBy.fullName")
    @Mapping(target = "attachmentId", source = "attachment.id")
    @Mapping(target = "attachmentDisplayName", source = "attachment.displayName")
    @Mapping(target = "attachmentFilePath", source = "attachment.filePath")
    @Mapping(target = "reviewedById", source = "reviewedBy.id")
    @Mapping(target = "reviewedByName", source = "reviewedBy.fullName")
    RoyaltyDistributionChangeRequestResponseDTO toDTO(
            RoyaltyDistributionChangeRequest entity
    );

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "process", source = "processId")
    @Mapping(target = "requestedBy", source = "requestedById")
    @Mapping(target = "attachment", source = "attachmentId")
    @Mapping(target = "currentUniversityPercentage", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "reviewedBy", ignore = true)
    @Mapping(target = "reviewedAt", ignore = true)
    @Mapping(target = "rejectionReason", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    void updateEntity(
            RoyaltyDistributionChangeRequestRequestDTO dto,
            @MappingTarget RoyaltyDistributionChangeRequest entity
    );

    default Process mapProcess(Long id) {
        if (id == null) {
            return null;
        }

        Process process = new Process();
        process.setId(id);
        return process;
    }

    default User mapUser(Long id) {
        if (id == null) {
            return null;
        }

        User user = new User();
        user.setId(id);
        return user;
    }

    default ChangeRequestAttachment mapAttachment(Long id) {
        if (id == null) {
            return null;
        }

        ChangeRequestAttachment attachment = new ChangeRequestAttachment();
        attachment.setId(id);
        return attachment;
    }
}