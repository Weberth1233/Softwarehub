package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.model.IpTypeDocument;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.repository.IpTypesDocumentRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class IpTypesDocumentService {
    private final IpTypesDocumentRepository repository;

    public IpTypeDocument save(IpTypeDocument ipTypeDocument) {
        return repository.save(ipTypeDocument);
    }

    public void update(IpTypeDocument ipTypeDocument){
        if(ipTypeDocument.getId() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que o usuário esteja cadastrado!");
        }
        repository.save(ipTypeDocument);
    }

    public List<IpTypeDocument> getIpTypeDocument(){
        return repository.findAll();
    }
}
