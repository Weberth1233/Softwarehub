package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "royalty_distribution_change_requests", schema = "public")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class RoyaltyDistributionChangeRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Processo que terá a cota da universidade alterada
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "process_id", nullable = false)
    private Process process;

    // Admin/usuário que solicitou a alteração
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "requested_by_id", nullable = false)
    private User requestedBy;

    @Column(name = "current_university_percentage", nullable = false, precision = 5, scale = 2)
    private BigDecimal currentUniversityPercentage;

    @Column(name = "requested_university_percentage", nullable = false, precision = 5, scale = 2)
    private BigDecimal requestedUniversityPercentage;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String justification;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "attachment_id", nullable = false)
    private ChangeRequestAttachment attachment;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private ChangeRequestStatus status = ChangeRequestStatus.PENDING;

    // Quem aprovou ou rejeitou
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reviewed_by_id")
    private User reviewedBy;

    @Column(name = "reviewed_at")
    private LocalDateTime reviewedAt;

    @Column(name = "rejection_reason", columnDefinition = "TEXT")
    private String rejectionReason;

    @CreatedDate
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}