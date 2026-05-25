package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.UserRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserUpdateDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.UserMapper;
import com.nitssrpi.NIT_SRPI.controller.mappers.UserUpdateMapper;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
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
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.net.URI;
import java.util.Optional;

@RestController
@RequestMapping("users")
@RequiredArgsConstructor
@Tag(name = "Usuário")
public class UserController  implements GenericController{
    private final UserService service;
    private final UserMapper mapper;
    private final UserUpdateMapper userUpdateMapper;

//    @PostMapping
//    @Operation(summary = "Salvar", description = "Cadastrar novo usuário")
//    @ApiResponses({
//            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
//            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
//            @ApiResponse(responseCode = "409", description = "Usuário já cadastrado!"),
//    })
//    public ResponseEntity<Object> save(@RequestBody @Valid UserRequestDTO dto) {
//        User user = mapper.toEntity(dto);
//        service.save(user);
//        URI location = generateHeaderLocation(user.getId());
//        return ResponseEntity.created(location).build();
//    }

    //Obter autor pelo id
    @GetMapping("{id}")
    @Operation(summary = "Obter por id", description = "Obter dados do usuário passando o Id como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Buscar realizada com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Usuario não encontrado!"),

    })
    public ResponseEntity<UserResponseDTO> getDetailsUser
    (@PathVariable("id") String id) {
        var idUser = Long.parseLong(id);
        return service.getUserById(idUser).map(user -> {
            UserResponseDTO dto = mapper.toDTO(user);
            return ResponseEntity.ok(dto);
        }).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar usuário passando o ID")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),
            @ApiResponse(responseCode = "404", description = "usuário não encontrado!"),

    })
    public ResponseEntity<Object> updateUser(@PathVariable("id") String id, @RequestBody @Valid UserUpdateDTO dto){
        var idUser = Long.parseLong(id);

        return service.getUserById(idUser).map(user -> {
            //Pegando o usuario do dto e criando um user
            User auxUser = userUpdateMapper.toEntity(dto);

            //Passando novos valores para o usuario encontrado com o id passado como parametro
            user.setUserName(auxUser.getUsername());
            user.setEmail(auxUser.getEmail());

            //Salvar a senha criptorafada de novo

            if (auxUser.getPassword() != null && !auxUser.getPassword().trim().isEmpty()) {
                // Se veio uma senha nova, criptografa e atualiza
                String encryptedPassword = new BCryptPasswordEncoder().encode(auxUser.getPassword());
                user.setPassword(encryptedPassword);
            }

            user.setPhoneNumber(auxUser.getPhoneNumber());
            user.setBirthDate(auxUser.getBirthDate());
            user.setProfession(auxUser.getProfession());
            user.setRole(auxUser.getRole());
            user.setIsEnabled(auxUser.getIsEnabled());

            user.getAddress().setStreet(auxUser.getAddress().getStreet());
            user.getAddress().setNumber(auxUser.getAddress().getNumber());
            user.getAddress().setComplement(auxUser.getAddress().getComplement());
            user.getAddress().setNeighborhood(auxUser.getAddress().getNeighborhood());
            user.getAddress().setCity(auxUser.getAddress().getCity());
            user.getAddress().setZipCode(auxUser.getAddress().getZipCode());

            service.update(user);
            return ResponseEntity.noContent().build();
        }).orElseGet(() -> ResponseEntity.notFound().build());

    }

    @GetMapping("/logged")
    @Operation(summary = "Obter dados ", description = "Obter dados do usuario logado")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
    })
    //logged-in user
    public ResponseEntity<UserResponseDTO> getLoggedUser() {
            UserResponseDTO dto = mapper.toDTO(service.getLoggedUser());
            return ResponseEntity.ok(dto);
    }

    @GetMapping
    @Operation(summary = "Pesquisar usuário", description = "Pesquisar usuário passando o user name, nome completo,cpf,email, página ou tamanho da página como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Busca realizada com sucesso!"),
    })
    public ResponseEntity<Page<UserResponseDTO>> pagedSearch(@RequestParam(value = "search", required = false) String search,
                                            @RequestParam(value = "page", defaultValue = "0") Integer page,
                                            @RequestParam(value = "page-size",  defaultValue = "10") Integer pageSize){
        Page<User> resultPage = service.searchUsers(search, page, pageSize);
        Page<UserResponseDTO> result = resultPage.map(mapper::toDTO);
        return ResponseEntity.ok(result);
    }

    //Obter autor pelo id
    @DeleteMapping("{id}")
    @Operation(summary = "Deletar", description = "Deletar passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Deletado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Item não encontrado!"),
    })
    public ResponseEntity<Object> delete
    (@PathVariable("id") String id) {
        var userId = Long.parseLong(id);
        //Buscando na base se existe alguem com esse id
        Optional<User> userOptional = service.getUserById(userId);
        //Se for vazio eu retorno notFound
        if(userOptional.isEmpty()){
            return ResponseEntity.notFound().build();
        }
        //Se não eu deleto
        service.delete(userOptional.get());
        return ResponseEntity.noContent().build();
    }
}
