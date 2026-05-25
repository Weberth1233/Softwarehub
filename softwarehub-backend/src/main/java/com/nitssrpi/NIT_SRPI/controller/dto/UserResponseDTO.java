package com.nitssrpi.NIT_SRPI.controller.dto;

import java.time.LocalDate;
import java.util.List;

public record UserResponseDTO(Long id, String userName, String email, String password,
                              String phoneNumber,
                              LocalDate birthDate,String profession, String fullName, String role, Boolean isEnabled, String cpf,
                              List<UserEducationalInstitutionLinkResponseDTO> userEducationalInstitutionLinks,
                              AddressResponseDTO address
) {

}
