package com.nitssrpi.NIT_SRPI.model;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FormStructure {

    private List<Field> fields;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Field {
        private String key;
        private String name;
        private String type;
        private Boolean required;
        private String placeholder;
        private Integer order;
        private Validation validation;
        private List<Option> options;
        private Conditional conditional;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Validation {
        private Integer minLength;
        private Integer maxLength;
        private Integer min;
        private Integer max;
        private String regex;
        private String message;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Option {
        private String label;
        private String value;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Conditional {
        private String dependsOn;
        private String operator;
        private Object value;
    }
}