package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class IpTypesService extends GenericServiceImpl<
        IpTypes,
        Long,
        IpTypesRepository> {

    public IpTypesService(IpTypesRepository repository) {
        super(repository);
    }

    @Override
    public IpTypes save(IpTypes ipTypes) {
        return super.save(ipTypes);
    }

    @Override
    public IpTypes update(IpTypes ipTypes) {
        if (ipTypes.getId() == null) {
            throw new EntityNotFoundException(
                    "Para atualizar é necessário que a propriedade intelectual esteja cadastrada!"
            );
        }

        if (!repository.existsById(ipTypes.getId())) {
            throw new EntityNotFoundException(
                    "Tipo de propriedade intelectual não encontrado!"
            );
        }

        return repository.save(ipTypes);
    }

    @Override
    public Long getEntityId(IpTypes ipTypes) {
        return ipTypes.getId();
    }
}