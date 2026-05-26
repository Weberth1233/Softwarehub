package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.Infra.security.SecurityService;
import com.nitssrpi.NIT_SRPI.controller.dto.UserEducationalInstitutionLinkResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.model.UserEducationalInstitutionLink;
import com.nitssrpi.NIT_SRPI.repository.UserRepository;
import com.nitssrpi.NIT_SRPI.repository.specs.UserSpecs;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository repository;

    @Transactional
    public User save(User user){
        if(user.getAddress() != null){
            //Diz para o endereço quem é o dono dele
            user.getAddress().setUser(user);
        }
        if(user.getUserEducationalInstitutionLinks() != null){
            for(UserEducationalInstitutionLink link: user.getUserEducationalInstitutionLinks()){
                link.setUser(user);
            }
        }
        if(repository.existsByCpf(user.getCpf())){
            throw new DuplicateRecordException("O CPF já está cadastrado no sistema!.");
        }
        if(repository.existsByEmail(user.getEmail())) {
            throw new DuplicateRecordException("O email já está cadastrado no sistema!.");
        }
        return repository.save(user);
    }

    public User getLoggedUser() {
        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("Usuário não autenticado");
        }

        return (User) authentication.getPrincipal();
    }

    public Optional<User> getUserById(Long id){
        return repository.findById(id);
    }

    public Page<User> searchUsers(String search, Integer page, Integer pageSize){
        Specification<User> specs = Specification.where((root, query, cb) -> cb.conjunction());

        if (search != null && !search.trim().isEmpty()) {
            specs = specs.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("userName")), "%" + search.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("fullName")), "%" + search.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("email")), "%" + search.toLowerCase() + "%"),
                    cb.equal(root.get("cpf"), search)
            ));
        }
        Pageable pageRequest = PageRequest.of(page, pageSize);
        return repository.findAll(specs, pageRequest);
    }

    public UserDetails findByEmail(String email){
        return repository.findByEmail(email);
    }

    public void update(User user){
        if(user.getId() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que o usuário esteja cadastrado!");
        }
        validateDuplicateCpfOrEmailForUpdate(user.getCpf(), user.getEmail(), user.getId());
        repository.save(user);
    }

    public void delete(User user){
        repository.delete(user);
    }

    private void validateDuplicateCpfOrEmailForUpdate(
            String cpf,
            String email,
            Long id
    ) {
        if (repository.existsByCpfAndIdNot(cpf, id)) {
            throw new DuplicateRecordException(
                    "Já existe um cpf cadastrado!"
            );
        }
        if (repository.existsByEmailAndIdNot(email, id)) {
            throw new DuplicateRecordException(
                    "Já existe um email cadastrado!"
            );
        }
    }

}
