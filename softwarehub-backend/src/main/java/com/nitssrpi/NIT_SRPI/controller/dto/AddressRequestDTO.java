package com.nitssrpi.NIT_SRPI.controller.dto;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Endereço")
public record AddressRequestDTO(String zipCode,
                                String street,
                                //String number,
                                String complement,
                                String neighborhood,
                                String city,
                                String state) {

}
