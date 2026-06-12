package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.ApplicationArea;
import com.nitssrpi.NIT_SRPI.repository.ApplicationAreaRepository;
import org.springframework.stereotype.Service;

@Service
public class ApplicationAreaService extends GenericServiceImpl<ApplicationArea, Long, ApplicationAreaRepository> {

    protected ApplicationAreaService(ApplicationAreaRepository repository) {
        super(repository);
    }

    @Override
    public Long getEntityId(ApplicationArea applicationArea) {
        return applicationArea.getId();
    }

    //Save validando se code já foi cadastrado para não dar erro 500

}
