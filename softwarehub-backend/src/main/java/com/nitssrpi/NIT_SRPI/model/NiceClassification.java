package com.nitssrpi.NIT_SRPI.model;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "nice_classification")
@Getter
@Setter
public class NiceClassification {
    @Id
    private Integer code;
    @Column(nullable = false)
    private String name;
    @Enumerated(EnumType.STRING)
    private NiceType type;
    @Column(columnDefinition = "TEXT")
    private String description;
}


