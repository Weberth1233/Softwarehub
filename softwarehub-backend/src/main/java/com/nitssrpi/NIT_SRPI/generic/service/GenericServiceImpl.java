package com.nitssrpi.NIT_SRPI.generic.service;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public abstract class GenericServiceImpl<
        ENTITY,
        ID,
        REPOSITORY extends JpaRepository<ENTITY, ID>>
        implements GenericService<ENTITY, ID> {

    protected final REPOSITORY repository;

    protected GenericServiceImpl(REPOSITORY repository) {
        this.repository = repository;
    }

    @Override
    public ENTITY save(ENTITY entity) {
        return repository.save(entity);
    }

    @Override
    public ENTITY update(ENTITY entity) {
        return repository.save(entity);
    }

    @Override
    public List<ENTITY> getAll() {
        return repository.findAll();
    }

    @Override
    public Optional<ENTITY> getById(ID id) {
        return repository.findById(id);
    }

    @Override
    public void delete(ENTITY entity) {
        repository.delete(entity);
    }
}
