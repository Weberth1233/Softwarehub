package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.controller.dto.UserResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserUpdateDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.UserMapper;
import com.nitssrpi.NIT_SRPI.controller.mappers.UserUpdateMapper;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("users")
@RequiredArgsConstructor
@Tag(name = "Usuário")
public class UserController implements GenericController {

    private final UserService service;
    private final UserMapper mapper;
    private final UserUpdateMapper userUpdateMapper;

    @GetMapping("{id}")
    @Operation(
            summary = "Obter por id",
            description = "Obter dados do usuário passando o ID como parâmetro"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado!")
    })
    public ResponseEntity<UserResponseDTO> getDetailsUser(@PathVariable Long id) {
        return service.getUserById(id)
                .map(user -> ResponseEntity.ok(mapper.toDTO(user)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("{id}")
    @Operation(
            summary = "Atualizar",
            description = "Atualizar usuário passando o ID"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado!")
    })
    public ResponseEntity<UserResponseDTO> updateUser(
            @PathVariable Long id,
            @RequestBody @Valid UserUpdateDTO dto
    ) {
        User user = userUpdateMapper.toEntity(dto);
        user.setId(id);

        User updatedUser = service.update(user);

        return ResponseEntity.noContent().build();
    }

    @GetMapping("/logged")
    @Operation(
            summary = "Obter dados do usuário logado",
            description = "Obter dados do usuário autenticado"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!")
    })
    public ResponseEntity<UserResponseDTO> getLoggedUser() {
        UserResponseDTO dto = mapper.toDTO(service.getLoggedUserData());
        return ResponseEntity.ok(dto);
    }

    @GetMapping
    @Operation(
            summary = "Pesquisar usuário",
            description = "Pesquisar usuário passando username, nome completo, CPF, email, página ou tamanho da página como parâmetro"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!")
    })
    public ResponseEntity<Page<UserResponseDTO>> pagedSearch(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "page", defaultValue = "0") Integer page,
            @RequestParam(value = "page-size", defaultValue = "10") Integer pageSize
    ) {
        Page<User> resultPage = service.searchUsers(search, page, pageSize);
        Page<UserResponseDTO> result = resultPage.map(mapper::toDTO);

        return ResponseEntity.ok(result);
    }

    @DeleteMapping("{id}")
    @Operation(
            summary = "Deletar",
            description = "Deletar usuário passando o ID como parâmetro"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Usuário não encontrado!")
    })
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        User user = service.getUserById(id)
                .orElse(null);

        if (user == null) {
            return ResponseEntity.notFound().build();
        }

        service.delete(user);

        return ResponseEntity.noContent().build();
    }
}