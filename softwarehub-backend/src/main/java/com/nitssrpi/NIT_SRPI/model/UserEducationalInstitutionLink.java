package com.nitssrpi.NIT_SRPI.model;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_educational_institution_links", schema = "public")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class UserEducationalInstitutionLink {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    // usuário
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    // Educação
    @ManyToOne
    @JoinColumn(name = "educational_institution_id")
    private EducationalInstitution educationalInstitution;
    // tipo de vínculo
    @ManyToOne
    @JoinColumn(name = "types_link_id")
    private TypesLink typesLink;
    @CreatedDate
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

}
