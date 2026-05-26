package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "consent_terms")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class ConsentTerm {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(columnDefinition = "TEXT")
    private String content;
    @CreatedDate
    private LocalDateTime createdAt;
    private Integer version;
    @OneToOne
    @JoinColumn(name = "ip_type_id", unique = true)
    private IpTypes ipType;
}
