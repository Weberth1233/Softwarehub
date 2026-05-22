package com.nitssrpi.NIT_SRPI.model;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
@Entity
@Table(name = "consent_term_acceptances")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class ConsentTermAcceptance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(optional = false)
    @JoinColumn(name = "consent_term_id")
    private ConsentTerm consentTerm;
    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id")
    private User user;
    @CreatedDate
    private LocalDateTime acceptedAt;
}
