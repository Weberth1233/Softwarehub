package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Table(name = "royalty_shares", schema = "public")
@Getter
@Setter
public class RoyaltyShare {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "distribution_id", nullable = false)
    private ProcessRoyaltyDistribution distribution;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private RoyaltyShareType type;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "external_author_id")
    private ExternalAuthor externalAuthor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "educational_institution_id")
    private EducationalInstitution educationalInstitution;

    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal percentage;
}