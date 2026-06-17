package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository repository;
    private final EducationalInstitutionService educationalInstitutionService;
    private final TypesLinkService typesLinkService;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public User save(User user) {
        prepareUserRelations(user);

        if (repository.existsByCpf(user.getCpf())) {
            throw new DuplicateRecordException("O CPF já está cadastrado no sistema!");
        }

        if (repository.existsByEmail(user.getEmail())) {
            throw new DuplicateRecordException("O email já está cadastrado no sistema!");
        }

        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("A senha é obrigatória!");
        }

        user.setRole(UserRole.USER);
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        return repository.save(user);
    }

    @Transactional
    public User update(User user) {
        if (user.getId() == null) {
            throw new EntityNotFoundException(
                    "Para atualizar é necessário que o usuário esteja cadastrado!"
            );
        }

        User existingUser = repository.findById(user.getId())
                .orElseThrow(() -> new EntityNotFoundException("Usuário não encontrado!"));

        UserRole currentRole = existingUser.getRole(); // guarda o role atual do banco

        validateDuplicateCpfOrEmailForUpdate(
                user.getCpf(),
                user.getEmail(),
                user.getId()
        );

        updateBasicData(existingUser, user);
        updatePassword(existingUser, user);
        updateAddress(existingUser, user);
        updateEducationalInstitutionLinks(existingUser, user);

        prepareUserRelations(existingUser);

        existingUser.setRole(currentRole); // restaura o role original

        return repository.save(existingUser);
    }

    @Transactional(readOnly = true)
    public User getLoggedUserData() {
        Long userId = getLoggedUserId();

        return repository.findByIdWithRelations(userId)
                .orElseThrow(() -> new EntityNotFoundException("Usuário não encontrado"));
    }

    public Long getLoggedUserId() {
        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("Usuário não autenticado");
        }

        User user = (User) authentication.getPrincipal();

        return user.getId();
    }

    public Optional<User> getUserById(Long id) {
        return repository.findById(id);
    }

    public Page<User> searchUsers(String search, Integer page, Integer pageSize) {
        Specification<User> specs = Specification.where(
                (root, query, cb) -> cb.conjunction()
        );

        if (search != null && !search.trim().isEmpty()) {
            String searchLowerCase = search.toLowerCase();

            specs = specs.and((root, query, cb) -> cb.or(
//                    cb.like(
//                            cb.lower(root.get("userName")),
//                            "%" + searchLowerCase + "%"
//                    ),
                    cb.like(
                            cb.lower(root.get("fullName")),
                            "%" + searchLowerCase + "%"
                    ),
                    cb.like(
                            cb.lower(root.get("email")),
                            "%" + searchLowerCase + "%"
                    ),
                    cb.equal(root.get("cpf"), search)
            ));
        }

        Pageable pageRequest = PageRequest.of(page, pageSize);

        return repository.findAll(specs, pageRequest);
    }

    public UserDetails findByEmail(String email) {
        return repository.findByEmail(email);
    }

    @Transactional
    public void delete(User user) {
        repository.delete(user);
    }

    private void updateBasicData(User existingUser, User user) {
        existingUser.setEmail(user.getEmail());
        existingUser.setCpf(user.getCpf());
        existingUser.setPhoneNumber(user.getPhoneNumber());
        existingUser.setBirthDate(user.getBirthDate());
        existingUser.setProfession(user.getProfession());
        existingUser.setFullName(user.getFullName());
        existingUser.setRole(user.getRole());
        existingUser.setIsEnabled(user.getIsEnabled());
    }

    private void updatePassword(User existingUser, User user) {
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            existingUser.setPassword(passwordEncoder.encode(user.getPassword()));
        }
    }

    private void updateAddress(User existingUser, User user) {
        if (user.getAddress() == null) {
            return;
        }

        if (existingUser.getAddress() == null) {
            existingUser.setAddress(user.getAddress());
            existingUser.getAddress().setUser(existingUser);
            return;
        }

        existingUser.getAddress().setZipCode(user.getAddress().getZipCode());
        existingUser.getAddress().setStreet(user.getAddress().getStreet());
//        existingUser.getAddress().setNumber(user.getAddress().getNumber());
        existingUser.getAddress().setComplement(user.getAddress().getComplement());
        existingUser.getAddress().setNeighborhood(user.getAddress().getNeighborhood());
        existingUser.getAddress().setCity(user.getAddress().getCity());
        existingUser.getAddress().setState(user.getAddress().getState());
    }

    private void updateEducationalInstitutionLinks(User existingUser, User user) {
        if (user.getUserEducationalInstitutionLinks() == null) {
            return;
        }

        existingUser.getUserEducationalInstitutionLinks().clear();

        for (UserEducationalInstitutionLink link : user.getUserEducationalInstitutionLinks()) {
            existingUser.getUserEducationalInstitutionLinks().add(link);
        }
    }

    private void prepareUserRelations(User user) {
        if (user.getAddress() != null) {
            user.getAddress().setUser(user);
        }

        if (user.getUserEducationalInstitutionLinks() != null) {
            for (UserEducationalInstitutionLink link : user.getUserEducationalInstitutionLinks()) {
                if (link.getEducationalInstitution() == null ||
                        link.getEducationalInstitution().getId() == null) {
                    throw new IllegalArgumentException(
                            "Instituição de ensino é obrigatória"
                    );
                }

                if (link.getTypesLink() == null ||
                        link.getTypesLink().getId() == null) {
                    throw new IllegalArgumentException(
                            "Vínculo é obrigatório"
                    );
                }

                EducationalInstitution institution =
                        educationalInstitutionService
                                .getById(link.getEducationalInstitution().getId())
                                .orElseThrow(() ->
                                        new EntityNotFoundException(
                                                "Instituição de ensino não encontrada!"
                                        )
                                );

                TypesLink typesLink =
                        typesLinkService
                                .getById(link.getTypesLink().getId())
                                .orElseThrow(() ->
                                        new EntityNotFoundException(
                                                "Vínculo não encontrado!"
                                        )
                                );

                link.setEducationalInstitution(institution);
                link.setTypesLink(typesLink);
                link.setUser(user);
            }
        }
    }

    private void validateDuplicateCpfOrEmailForUpdate(
            String cpf,
            String email,
            Long id
    ) {
        if (repository.existsByCpfAndIdNot(cpf, id)) {
            throw new DuplicateRecordException(
                    "Já existe um CPF cadastrado!"
            );
        }

        if (repository.existsByEmailAndIdNot(email, id)) {
            throw new DuplicateRecordException(
                    "Já existe um email cadastrado!"
            );
        }
    }
}