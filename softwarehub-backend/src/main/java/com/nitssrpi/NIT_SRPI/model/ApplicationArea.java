package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "application_area")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class ApplicationArea {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Ex: AD, AG, SD, TP
    @Column(nullable = false, unique = true, length = 10)
    private String code;

    // Ex: Administração, Agricultura, Saúde
    @Column(nullable = false, length = 120)
    private String name;

    @Column(name = "display_order")
    private Integer displayOrder;

    @Column(nullable = false)
    private Boolean active = true;

    @OneToMany(mappedBy = "applicationArea")
    private List<ApplicationField> fields = new ArrayList<>();

    @Column(name = "created_at")
    @CreatedDate
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    @LastModifiedDate
    private LocalDateTime updatedAt;


}