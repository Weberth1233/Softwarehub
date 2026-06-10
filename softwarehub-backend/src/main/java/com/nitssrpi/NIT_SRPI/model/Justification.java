package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "justifications")
@Getter
@Setter
public class Justification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(columnDefinition = "TEXT", nullable = false)
    private String reason;
    @ManyToOne
    @JoinColumn(name = "process_id", nullable = false)
    private Process process;
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
    @OneToOne(mappedBy = "justification", cascade = CascadeType.ALL, orphanRemoval = true)
    private JustificationAttachment attachment;
}
