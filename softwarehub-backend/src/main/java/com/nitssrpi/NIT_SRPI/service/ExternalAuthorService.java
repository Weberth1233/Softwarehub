package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.Infra.security.SecurityService;
import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.repository.ExternalAuthorRepository;
import com.nitssrpi.NIT_SRPI.repository.specs.ExternalAuthorSpecs;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ExternalAuthorService {
    private final ExternalAuthorRepository repository;
    private final SecurityService securityService;

    public ExternalAuthor save(ExternalAuthor externalAuthor){
        // Validação preventiva
        if (repository.existsByCpf(externalAuthor.getCpf())) {
            throw new DuplicateRecordException("O CPF " + externalAuthor.getCpf() + " já está cadastrado no sistema!.");
        }
        if (repository.existsByEmail(externalAuthor.getEmail())) {
            throw new DuplicateRecordException("O Email " + externalAuthor.getEmail() + " já está cadastrado no sistema!.");
        }
        User user = securityService.getAuthenticatedUser();
        externalAuthor.setOwner(user);
        externalAuthor.setActive(true);
        return repository.save(externalAuthor);
    }

    public void update(ExternalAuthor externalAuthor){
        if(externalAuthor.getId() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que o usuário esteja cadastrado!");
        }
        repository.save(externalAuthor);
    }

    public Optional<ExternalAuthor> getById(Long id){
        return repository.findById(id);
    }

    public List<ExternalAuthor> getAll(){
        return repository.findAll();
    }

    public void delete(ExternalAuthor externalAuthor){
        externalAuthor.setActive(false);
        repository.save(externalAuthor);
    }

    public Page<ExternalAuthor> userExternalAuthors(String search, Integer page, Integer pageSize) {
        // 1. Pega o usuário logado
        User user = securityService.getAuthenticatedUser();

        Specification<ExternalAuthor> specs = Specification
                .where(ExternalAuthorSpecs.isActive()) // <-- NOVIDADE AQUI!
                .and(ExternalAuthorSpecs.equalOwnerId(user.getId()));

        if (search != null && !search.trim().isEmpty()) {
            specs = specs.and((root, query, cb) -> cb.or(
                    cb.like(cb.lower(root.get("fullName")), "%" + search.toLowerCase() + "%"),
                    cb.like(cb.lower(root.get("email")), "%" + search.toLowerCase() + "%"),
                    cb.equal(root.get("cpf"), search)
            ));
        }

        // 4. Configura a paginação
        Pageable pageable = PageRequest.of(page, pageSize);
        // 5. Chama o findAll (que vem do JpaSpecificationExecutor)
        return repository.findAll(specs, pageable);
    }
}

