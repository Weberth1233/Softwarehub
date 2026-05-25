package com.nitssrpi.NIT_SRPI.generic.service;

import java.util.List;
import java.util.Optional;

public interface GenericService<ENTITY, ID> {
    ENTITY save(ENTITY entity);
    ENTITY update(ENTITY entity);
    List<ENTITY> getAll();
    Optional<ENTITY> getById(ID id);
    void delete(ENTITY entity);
    ID getEntityId(ENTITY entity);
}
