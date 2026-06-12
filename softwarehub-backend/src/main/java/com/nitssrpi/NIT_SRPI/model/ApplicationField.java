package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "application_field")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class ApplicationField {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Ex: AD01, AG01, SD01
    @Column(nullable = false, unique = true, length = 10)
    private String code;

    // Ex: Administração, Saúde, Transporte
    @Column(nullable = false, length = 150)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Boolean active = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "application_area_id", nullable = false)
    private ApplicationArea applicationArea;

    @ManyToMany(mappedBy = "applicationFields")
    private Set<Process> processes = new HashSet<>();

    @Column(name = "created_at")
    @CreatedDate
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    @LastModifiedDate
    private LocalDateTime updatedAt;

}