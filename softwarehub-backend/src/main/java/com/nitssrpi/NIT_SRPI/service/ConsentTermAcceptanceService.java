package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.Infra.security.SecurityService;
import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.ConsentTermAcceptance;
import com.nitssrpi.NIT_SRPI.model.User;
import com.nitssrpi.NIT_SRPI.repository.ConsentTermAcceptanceRepository;
import com.nitssrpi.NIT_SRPI.repository.ConsentTermRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class ConsentTermAcceptanceService extends GenericServiceImpl<
        ConsentTermAcceptance,
        Long,
        ConsentTermAcceptanceRepository> {

    private final ConsentTermRepository consentTermRepository;
    private final SecurityService securityService;

    public ConsentTermAcceptanceService(
            ConsentTermAcceptanceRepository repository,
            ConsentTermRepository consentTermRepository,
            SecurityService securityService
    ) {
        super(repository);
        this.consentTermRepository = consentTermRepository;
        this.securityService = securityService;
    }

    @Override
    public ConsentTermAcceptance save(ConsentTermAcceptance consentTermAcceptance) {
        User user = securityService.getAuthenticatedUser();

        Long consentTermId = consentTermAcceptance.getConsentTerm() != null
                ? consentTermAcceptance.getConsentTerm().getId()
                : null;

        if (consentTermId == null) {
            throw new EntityNotFoundException("O termo de consentimento é obrigatório!");
        }

        ConsentTerm consentTerm = consentTermRepository.findById(consentTermId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Termo de consentimento não encontrado!"
                ));

        consentTermAcceptance.setUser(user);
        consentTermAcceptance.setConsentTerm(consentTerm);

        return super.save(consentTermAcceptance);
    }

    public ConsentTermAcceptance update(ConsentTermAcceptance consentTermAcceptance) {
        if (consentTermAcceptance.getId() == null) {
            throw new EntityNotFoundException(
                    "Para atualizar é necessário que o termo de concordância esteja cadastrado!"
            );
        }

        return super.save(consentTermAcceptance);
    }

    @Override
    public Long getEntityId(ConsentTermAcceptance consentTermAcceptance) {
        return consentTermAcceptance.getId();
    }

    public boolean consentTermWasAccepted(Long consentTermId) {
        User user = securityService.getAuthenticatedUser();

        ConsentTerm consentTerm = consentTermRepository.findById(consentTermId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Termo de consentimento não encontrado!"
                ));

        return repository.existsByUserAndConsentTerm(user, consentTerm);
    }
}