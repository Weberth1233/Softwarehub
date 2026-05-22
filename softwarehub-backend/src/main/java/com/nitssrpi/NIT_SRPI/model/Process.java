package com.nitssrpi.NIT_SRPI.model;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Entity
@Table(name = "processes", schema = "public")
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class)
public class Process {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "varchar(255)") // Força a coluna a ser apenas um texto sem Check
    private StatusProcess status;

    @Column(name = "is_featured")
    private boolean isFeatured;

    @CreatedDate
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Type(JsonBinaryType.class)
    @Column(name = "form_data", columnDefinition = "jsonb")
    private Map<String, Object> formData;

    //MUITOS PROJETOS PERTENCEM A UM UNICO TIPO DE PI
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ip_type_id", nullable = false)
    private IpTypes ipType;
    // Relacionamento Muitos-para-Muitos com Autores (Users)
    // O Spring criará a tabela intermediária 'project_authors'

    @ManyToMany
    @JoinTable(name = "process_external_authors", joinColumns = @JoinColumn(name = "process_id"), inverseJoinColumns = @JoinColumn(name = "external_author_id"))
    private List<ExternalAuthor> externalAuthors = new ArrayList<>();

    @ManyToMany
    @JoinTable(
            name = "process_authors",
            joinColumns = @JoinColumn(name = "process_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private List<User> authors = new ArrayList<>();
    // Um projeto pode ter vários anexos
    // CascadeType.ALL garante que ao deletar o projeto, os registros de anexos sumam
    @OneToMany(mappedBy = "process", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Attachment> attachments = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "creator_id", nullable = false) // Mapeia a coluna que o banco está reclamando
    private User creator;

    @OneToMany(mappedBy = "process", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Justification> justifications = new ArrayList<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "nice_class_code", nullable = true)
    private NiceClassification niceClassification;
}
