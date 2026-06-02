package com.nitssrpi.NIT_SRPI.controller.dto;

public record AddressResponseDTO(String zipCode,
                                 String street,
                                // String number,
                                 String complement,
                                 String neighborhood,
                                 String city,
                                 String state) {
}
