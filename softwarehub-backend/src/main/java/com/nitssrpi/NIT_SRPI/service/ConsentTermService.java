package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.repository.ConsentTermRepository;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class ConsentTermService extends GenericServiceImpl<
        ConsentTerm,
        Long,
        ConsentTermRepository> {

    private final IpTypesRepository ipTypesRepository;

    public ConsentTermService(
            ConsentTermRepository repository,
            IpTypesRepository ipTypesRepository
    ) {
        super(repository);
        this.ipTypesRepository = ipTypesRepository;
    }

    @Override
    public ConsentTerm save(ConsentTerm consentTerm) {
        Long ipTypeId = getIpTypeIdOrThrow(consentTerm);

        IpTypes ipType = ipTypesRepository.findById(ipTypeId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Tipo de propriedade intelectual não encontrado!"
                ));

        if (repository.existsByIpTypeId(ipTypeId)) {
            throw new DuplicateRecordException(
                    "Já existe um termo para esse tipo de propriedade intelectual"
            );
        }

        consentTerm.setIpType(ipType);

        return repository.save(consentTerm);
    }

    @Override
    public ConsentTerm update(ConsentTerm consentTerm) {
        if (consentTerm.getId() == null) {
            throw new EntityNotFoundException(
                    "Para atualizar é necessário que o termo de concordância esteja cadastrado!"
            );
        }

        if (!repository.existsById(consentTerm.getId())) {
            throw new EntityNotFoundException(
                    "Termo de consentimento não encontrado!"
            );
        }

        Long ipTypeId = getIpTypeIdOrThrow(consentTerm);

        IpTypes ipType = ipTypesRepository.findById(ipTypeId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Tipo de propriedade intelectual não encontrado!"
                ));

        validateDuplicateIpTypeForUpdate(ipTypeId, consentTerm.getId());

        consentTerm.setIpType(ipType);

        return repository.save(consentTerm);
    }

    @Override
    public Long getEntityId(ConsentTerm consentTerm) {
        return consentTerm.getId();
    }

    public ConsentTerm getByIpTypeId(Long id) {
        return repository.findByIpTypeId(id)
                .orElseThrow(() -> new EntityNotFoundException(
                        "Termo não encontrado!"
                ));
    }

    private Long getIpTypeIdOrThrow(ConsentTerm consentTerm) {
        if (consentTerm.getIpType() == null || consentTerm.getIpType().getId() == null) {
            throw new EntityNotFoundException(
                    "Tipo de propriedade intelectual é obrigatório!"
            );
        }

        return consentTerm.getIpType().getId();
    }

    private void validateDuplicateIpTypeForUpdate(
            Long ipTypeId,
            Long id
    ) {
        if (repository.existsByIpTypeIdAndIdNot(ipTypeId, id)) {
            throw new DuplicateRecordException(
                    "Já existe um termo para esse tipo de propriedade intelectual"
            );
        }
    }
}