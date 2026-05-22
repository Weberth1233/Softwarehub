package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.ConsentTermAcceptance;
import com.nitssrpi.NIT_SRPI.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConsentTermAcceptanceRepository  extends JpaRepository<ConsentTermAcceptance, Long> {
    boolean existsByUserAndConsentTerm(
            User user,
            ConsentTerm consentTerm
    );
}
