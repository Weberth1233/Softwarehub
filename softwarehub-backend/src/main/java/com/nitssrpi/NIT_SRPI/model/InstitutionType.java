package com.nitssrpi.NIT_SRPI.model;

import com.fasterxml.jackson.annotation.JsonValue;

public enum InstitutionType {
    SCHOOL("Escola"),
    UNIVERSITY("Universidade"),
    TECHNICAL("Técnico"),
    ONLINE("Online");

    private final String description;

    InstitutionType(String description) {
        this.description = description;
    }

    @JsonValue
    public String getDescription() {
        return description;
    }
}
