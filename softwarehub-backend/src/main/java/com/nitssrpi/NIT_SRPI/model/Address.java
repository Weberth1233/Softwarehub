package com.nitssrpi.NIT_SRPI.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "addresses", schema = "public")
@Getter
@Setter
public class Address {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String street;
   // private String number;
    private String complement;
    private String neighborhood;
    private String city;
    private String state;
    @Column(name = "zip_code")
    private String zipCode;
    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;
}
