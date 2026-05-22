package com.nitssrpi.NIT_SRPI.controller;

import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;

public interface GenericController {
    default URI generateHeaderLocation(Long id){
        return ServletUriComponentsBuilder.
                fromCurrentRequest().
                path("/{id}")
                .buildAndExpand(id).
                toUri();
    }

    default URI generateHeaderLocationInteger(Integer id){
        return ServletUriComponentsBuilder.
                fromCurrentRequest().
                path("/{id}")
                .buildAndExpand(id).
                toUri();
    }
}
