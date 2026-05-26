package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.controller.dto.AddressRequestDTO;
import com.nitssrpi.NIT_SRPI.model.UserRole;
import jakarta.validation.constraints.*;
import org.hibernate.validator.constraints.br.CPF;

import java.time.LocalDate;

public record UserUpdateDTO(
        @NotBlank(message = "Campo obrigatório!")
        String userName,

        @NotBlank(message = "O CPF é obrigatório")
        @CPF(message = "CPF inválido")
        String cpf,

        @Email(message = "Email inválido!")
        String email,

        // 👇 REMOVEMOS O @NotBlank DAQUI!
        // Assim, o Spring permite que a senha venha vazia na hora de editar
        String password,

        @NotBlank(message = "O telefone é obrigatório")
        @Pattern(
                regexp = "^\\(?([1-9]{2})\\)?[-. ]?([9])?([-  ]?)?(\\d{4})[-. ]?(\\d{4})$",
                message = "O número de telefone informado é inválido"
        )
        String phoneNumber,

        @Past(message = "Não pode ser uma data futura!")
        LocalDate birthDate,

        String profession,

        @NotBlank(message = "Campo obrigatório!")
        String fullName,

        UserRole role,
        Boolean isEnabled,
        AddressRequestDTO address) {
}