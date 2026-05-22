package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.repository.ConsentTermRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ConsentTermService {
    private final ConsentTermRepository repository;

    public ConsentTerm save(ConsentTerm consentTerm){
        return repository.save(consentTerm);
    }

    public void update(ConsentTerm consentTerm){
        if(consentTerm.getId() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que o termo de concordância esteja cadastrado!");
        }
        repository.save(consentTerm);
    }

    public Optional<ConsentTerm> getById(Long id){
        return repository.findById(id);
    }

    public void delete(ConsentTerm consentTerm) {
        repository.delete(consentTerm);
    }

    public List<ConsentTerm> getAll(){
        return repository.findAll();
    }
}
