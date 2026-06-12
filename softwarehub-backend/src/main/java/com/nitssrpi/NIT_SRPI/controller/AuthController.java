package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth/")
@CrossOrigin(origins = "*")
@Tag(name = "Esqueci a senha")
public class AuthController {
    @Autowired // <--- ESSA ANOTAÇÃO É OBRIGATÓRIA
    private AuthService authService;

    // Rota para o Flutter pedir o envio do e-mail
    @PostMapping("/forgot-password")
    @Operation(summary = "Esqueceu senha", description = "Api para esqueceu senha passando o email para validação da conta")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Token enviado com sucesso!")
    })
    public ResponseEntity<?> forgotPassword(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        authService.initiatePasswordReset(email);
        return ResponseEntity.ok().body("{\"message\": \"Se o e-mail existir, o código foi enviado.\"}");
    }

    // Rota para o Flutter enviar o código + a nova senha
    @PostMapping("/reset-password")
    @Operation(summary = "Mudar senha", description = "Mudar senha passando o token recebido e nova senha")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Senha alterada com sucesso!")
    })
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> body) {
        String token = body.get("token");
        String newPassword = body.get("newPassword");

        try {
            authService.updatePassword(token, newPassword);
            return ResponseEntity.ok().body("{\"message\": \"Senha atualizada com sucesso!\"}");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

}
