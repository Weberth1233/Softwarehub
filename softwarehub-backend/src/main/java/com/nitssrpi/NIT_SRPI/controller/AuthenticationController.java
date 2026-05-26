package com.nitssrpi.NIT_SRPI.controller;


import com.nitssrpi.NIT_SRPI.Infra.security.TokenService;
import com.nitssrpi.NIT_SRPI.controller.dto.AuthenticationDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.LoginResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.UserRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.UserMapper;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import com.nitssrpi.NIT_SRPI.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.URI;

@RestController
@RequestMapping("auth")
@Tag(name = "Autenticação usuário")
public class AuthenticationController implements GenericController{
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private UserService service;
    @Autowired
    TokenService tokenService;
    @Autowired
    UserMapper mapper;


    @PostMapping("/login")
    @Operation(summary = "Logar", description = "login passando o email e senha")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Login realizada com sucesso!"),
            @ApiResponse(responseCode = "401", description = "Credenciais inválidas!")
    })
    public ResponseEntity<?> login(@RequestBody @Valid AuthenticationDTO data) {
        try {
            var userNamePassword = new UsernamePasswordAuthenticationToken(data.email(), data.password());
            var auth = this.authenticationManager.authenticate(userNamePassword);

            var token = tokenService.generateToken((User) auth.getPrincipal());
            System.out.println(((User) auth.getPrincipal()).getRole());
            return ResponseEntity.ok(new LoginResponseDTO(token, ((User) auth.getPrincipal()).getRole()));
        } catch (BadCredentialsException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Credenciais inválidas!");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Ocorreu um erro durante a autenticação.");
        }
    }

    @PostMapping("/register")
    @Operation(summary = "Cadastro", description = "Cadastro de usuário")
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Cadastrado com sucesso!"),
            @ApiResponse(responseCode = "422", description = "Erro de validação!"),

    })
    public ResponseEntity<Object> save(@RequestBody @Valid UserRequestDTO dto) {
        if(this.service.findByEmail(dto.email()) != null) return ResponseEntity.badRequest().build();
        String encryptedPassword = new BCryptPasswordEncoder().encode(dto.password());
        User user = mapper.toEntity(dto);
        System.out.println(user.getUsername());
        user.setPassword(encryptedPassword);

        this.service.save(user);
        URI location = generateHeaderLocation(user.getId());
        return ResponseEntity.created(location).build();
    }

}
