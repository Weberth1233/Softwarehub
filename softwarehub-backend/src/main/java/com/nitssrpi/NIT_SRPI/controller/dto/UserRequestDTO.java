package com.nitssrpi.NIT_SRPI.controller.dto;

import com.nitssrpi.NIT_SRPI.model.UserRole;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import org.hibernate.validator.constraints.br.CPF;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDate;
import java.util.List;

@Schema(name = "Usuário")
public record UserRequestDTO(

        @NotBlank(message = "O email é obrigatório")
        @Email(message = "Email inválido")
        @Size(
                max = 150,
                message = "O email deve ter no máximo 150 caracteres"
        )
        String email,

        @NotBlank(message = "A senha é obrigatória")
        @Size(
                min = 8,
                max = 100,
                message = "A senha deve ter entre 8 e 100 caracteres"
        )
        @Pattern(
                regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).+$",
                message = "A senha deve conter pelo menos uma letra maiúscula, uma minúscula e um número"
        )
        String password,

        @NotBlank(message = "O CPF é obrigatório")
        @CPF(message = "CPF inválido")
        String cpf,

        @NotBlank(message = "O telefone é obrigatório")
        @Pattern(
                regexp = "^\\(?([1-9]{2})\\)?\\s?(9\\d{4})-?(\\d{4})$",
                message = "Número de telefone inválido"
        )
        String phoneNumber,

        @NotNull(message = "A data de nascimento é obrigatória")
        @Past(message = "A data de nascimento deve ser uma data passada")
        LocalDate birthDate,

        @Size(
                max = 100,
                message = "A profissão deve ter no máximo 100 caracteres"
        )
        String profession,

        @NotBlank(message = "O nome completo é obrigatório")
        @Size(
                min = 3,
                max = 255,
                message = "O nome completo deve ter entre 3 e 255 caracteres"
        )
        @Pattern(
                regexp = "^[A-Za-zÀ-ÿ\\s]+$",
                message = "O nome completo deve conter apenas letras"
        )
        String fullName,

        @NotEmpty(message = "O usuário deve possuir pelo menos um vínculo institucional")
        @Valid
        List<UserEducationalInstitutionLinkRequestDTO> userEducationalInstitutionLinks,

        @NotNull(message = "O status do usuário é obrigatório")
        Boolean isEnabled,

        @NotNull(message = "O endereço é obrigatório")
        @Valid
        AddressRequestDTO address

) {
}
