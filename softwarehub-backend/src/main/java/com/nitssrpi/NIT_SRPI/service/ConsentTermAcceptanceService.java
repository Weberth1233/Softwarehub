package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.Infra.security.SecurityService;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.ConsentTermAcceptance;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.repository.ConsentTermAcceptanceRepository;
import com.nitssrpi.NIT_SRPI.repository.ConsentTermRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ConsentTermAcceptanceService {
    private final ConsentTermAcceptanceRepository repository;
    private final ConsentTermRepository consentTermRepository;
    private final SecurityService securityService;

    public ConsentTermAcceptance save(ConsentTermAcceptance consentTermAcceptance){
        //Pegando dados do usuario autenticado no sistema
        User user = securityService.getAuthenticatedUser();
        consentTermAcceptance.setUser(user);

        return repository.save(consentTermAcceptance);
    }

    public void update(ConsentTermAcceptance consentTermAcceptance){
        if(consentTermAcceptance.getId() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que o termo de concordância esteja cadastrado!");
        }
        repository.save(consentTermAcceptance);
    }

    public Optional<ConsentTermAcceptance> getById(Long id){
        return repository.findById(id);
    }

    public void delete(ConsentTermAcceptance consentTermAcceptance) {
        repository.delete(consentTermAcceptance);
    }

    public List<ConsentTermAcceptance> getAll(){
        return repository.findAll();
    }

    public boolean consentTermWasAccepted(Long consertTermId){
        User user = securityService.getAuthenticatedUser();
        ConsentTerm consentTerm =  consentTermRepository.findById(consertTermId).orElseThrow(() -> new EntityNotFoundException("Termo de consentimento não encontrado!"));
        return repository.existsByUserAndConsentTerm(user, consentTerm);
    }
}
