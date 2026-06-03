package com.nitssrpi.NIT_SRPI.Infra.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true, jsr250Enabled = true)
public class SecurityConfiguration {

    @Autowired
    SecurityFilter securityFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                // 1. CORS deve vir ANTES de tudo
                .cors(Customizer.withDefaults())
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(authorize -> authorize
                                // 2. Libera explicitamente o "pre-flight" do navegador
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

                        .requestMatchers(HttpMethod.POST, "/auth/login").permitAll()
                        .requestMatchers(HttpMethod.POST, "/auth/register").permitAll()
                                .requestMatchers(HttpMethod.POST, "api/auth/forgot-password").permitAll()
                                .requestMatchers(HttpMethod.POST, "api/auth/reset-password").permitAll()

                                .requestMatchers(HttpMethod.GET, "educational-institution").permitAll()
                                .requestMatchers(HttpMethod.POST, "/educational-institution/**").hasRole("ADMIN")
                                .requestMatchers(HttpMethod.PUT, "/educational-institution/**").hasRole("ADMIN")
                                .requestMatchers(HttpMethod.DELETE, "/educational-institution/**").hasRole("ADMIN")

                                .requestMatchers(HttpMethod.GET, "types-link").permitAll()
                                .requestMatchers(HttpMethod.POST, "/types-link/**").hasRole("ADMIN")
                                .requestMatchers(HttpMethod.PUT, "/types-link/**").hasRole("ADMIN")
                                .requestMatchers(HttpMethod.DELETE, "/types-link/**").hasRole("ADMIN")

                        // IpTypes - ROLES
                        .requestMatchers(HttpMethod.GET, "/ip_types/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.POST, "/ip_types/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/ip_types/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/ip_types/**").hasRole("ADMIN")

                                .requestMatchers(HttpMethod.GET, "/attachments/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.POST, "/attachments/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.PUT, "/attachments/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.DELETE, "/attachments/**").hasRole("ADMIN")

                                .requestMatchers(HttpMethod.GET, "/ip_types_documents/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.POST, "/ip_types_documents/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.PUT, "/ip_types_documents/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.DELETE, "/ip_types_documents/**").hasRole("ADMIN")

                                .requestMatchers(HttpMethod.GET, "/justification/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.POST, "/justification/**").hasRole("ADMIN")
                                .requestMatchers(HttpMethod.PUT, "/justification/**").hasRole("ADMIN")
                                .requestMatchers(HttpMethod.DELETE, "/justification/**").hasRole("ADMIN")

                                .requestMatchers(HttpMethod.GET, "/users/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.POST, "/users/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.PUT, "/users/**").hasAnyRole("ADMIN", "USER")
                                .requestMatchers(HttpMethod.DELETE, "/users/**").hasRole("ADMIN")

                        // Process - ROLES
//                        .requestMatchers(HttpMethod.GET, "/process/user/processes").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.GET, "/process/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.POST, "/process/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.PUT, "/process/**").hasAnyRole("ADMIN", "USER")
                        .requestMatchers(HttpMethod.DELETE, "/process/**").hasAnyRole("ADMIN", "USER")
                        .anyRequest().authenticated()
                )
                .addFilterBefore(securityFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer(){
        return web -> web.ignoring().requestMatchers(
                "/v2/api-docs/**",
                "/v3/api-docs/**",
                "/swagger-resources/**",
                "/swagger-ui.html",
                "/swagger-ui/**",
                "/webjars/**"
        );
    }


    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();

        // Permite qualquer porta no localhost (ideal para Flutter Web)
        config.setAllowedOriginPatterns(List.of(
                "http://localhost:[*]",
                "http://127.0.0.1:[*]"
        ));

        // Métodos necessários para APIs REST
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));

        // Headers que o Flutter costuma enviar
        config.setAllowedHeaders(List.of(
                "Origin",
                "Content-Type",
                "Accept",
                "Authorization",
                "X-Requested-With"
        ));

        // Permite envio de Credentials (necessário se usar cookies ou Header Auth)
        config.setAllowCredentials(true);

        // Expõe headers para que o Flutter consiga ler (ex: se o Token vier no Header)
        config.setExposedHeaders(List.of("Authorization"));

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}