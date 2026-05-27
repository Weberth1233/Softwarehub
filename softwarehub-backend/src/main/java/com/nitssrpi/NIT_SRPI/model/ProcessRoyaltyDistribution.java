package com.nitssrpi.NIT_SRPI.model;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "process_royalty_distribution", schema = "public")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class ProcessRoyaltyDistribution {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    // Processo ao qual essa distribuição pertence
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "process_id", nullable = false)
    private Process process;

    // Versão da distribuição. Ex: 1, 2, 3...
    @Column(nullable = false)
    private Integer version;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private RoyaltyDistributionStatus status = RoyaltyDistributionStatus.DRAFT;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "change_request_id")
    private RoyaltyDistributionChangeRequest changeRequest;

    @CreatedDate
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(
            mappedBy = "distribution",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private List<RoyaltyShare> shares = new ArrayList<>();
}