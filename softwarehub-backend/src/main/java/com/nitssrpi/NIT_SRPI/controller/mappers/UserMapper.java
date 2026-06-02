package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.UserRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserResponseDTO;
import com.nitssrpi.NIT_SRPI.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(
        componentModel = "spring",
        uses = {
                UserEducationalInstitutionLinkMapper.class,
        }
)
public interface UserMapper {
    User toEntity(UserRequestDTO dto);
    @Mapping(target = "userName", source = "username")
    UserResponseDTO toDTO(User user);
}