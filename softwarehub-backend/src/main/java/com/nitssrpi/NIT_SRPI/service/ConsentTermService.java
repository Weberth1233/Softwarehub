package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.repository.ConsentTermRepository;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ConsentTermService {
    private final ConsentTermRepository repository;
    private final IpTypesRepository ipTypesRepository;

    public ConsentTerm save(ConsentTerm consentTerm) {
        Long ipTypeId = consentTerm.getIpType().getId();
        //Verifico se existe uma tipo de propriedade intelectual já cadastrada
        if (!ipTypesRepository.existsById(ipTypeId)) {
            throw new EntityNotFoundException("Tipo de propriedade intelectual não encontrado");
        }
        //Verifico se o tipo de propriedade já foi cadastrada e vinculada a um termo
        if(repository.existsByIpTypeId(ipTypeId)){
            throw new DuplicateRecordException("Já há um tipo de propriedade intelectual cadastrado para esse termo de consentimento");
        }
        return repository.save(consentTerm);
    }

    public void update(ConsentTerm consentTerm){
        if(consentTerm.getId() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que o termo de concordância esteja cadastrado!");
        }
        validateDuplicateIpTypeForUpdate(consentTerm.getIpType().getId(), consentTerm.getId());
        repository.save(consentTerm);
    }

    public Optional<ConsentTerm> getById(Long id){
        return repository.findById(id);
    }

    public void delete(ConsentTerm consentTerm) {
        repository.delete(consentTerm);
    }

    public List<ConsentTerm> getAll(){
        return repository.findAll();
    }

    public ConsentTerm getByIpTypeId(Long id){
        return repository.findByIpTypeId(id).orElseThrow(() -> new EntityNotFoundException("Termo não encontrado!"));
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
