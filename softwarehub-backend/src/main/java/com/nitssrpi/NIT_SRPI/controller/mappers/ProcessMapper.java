package com.nitssrpi.NIT_SRPI.controller.mappers;

import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessResponseDTO;
import com.nitssrpi.NIT_SRPI.model.ExternalAuthor;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import com.nitssrpi.NIT_SRPI.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = {
                IpTypesMapper.class,
                UserMapper.class,
                NiceClassificationMapper.class,
                ProcessRoyaltyDistributionMapper.class
        }
)
public interface ProcessMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)

    @Mapping(target = "creator", ignore = true)
//    @Mapping(target = "niceClassification", ignore = true)

    @Mapping(target = "attachments", ignore = true)
    @Mapping(target = "justifications", ignore = true)
    @Mapping(target = "royaltyDistributions", ignore = true)

    @Mapping(target = "ipType", source = "ipTypeId")
    @Mapping(target = "authors", source = "authorIds")
    @Mapping(target = "externalAuthors", source = "externalAuthorsIds")
    Process toEntity(ProcessRequestDTO dto);

    @Mapping(target = "statusLabel", expression = "java(getStatusLabel(process.getStatus()))")
    ProcessResponseDTO toDTO(Process process);

    default String getStatusLabel(StatusProcess status) {
        if (status == null) {
            return null;
        }

        return status.getLabel();
    }

    default IpTypes mapIpTypes(Long id) {
        if (id == null) {
            return null;
        }

        IpTypes ipTypes = new IpTypes();
        ipTypes.setId(id);
        return ipTypes;
    }

    default ExternalAuthor mapExternalAuthor(Long id) {
        if (id == null) {
            return null;
        }

        ExternalAuthor externalAuthor = new ExternalAuthor();
        externalAuthor.setId(id);
        return externalAuthor;
    }

    default User mapUser(Long id) {
        if (id == null) {
            return null;
        }

        User user = new User();
        user.setId(id);
        return user;
    }
}