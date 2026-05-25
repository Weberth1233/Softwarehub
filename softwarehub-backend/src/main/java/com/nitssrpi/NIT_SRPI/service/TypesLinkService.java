package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.TypesLink;
import com.nitssrpi.NIT_SRPI.repository.TypesLinkRepository;
import org.springframework.stereotype.Service;

@Service
public class TypesLinkService extends
        GenericServiceImpl<
                TypesLink,
                Long,
                TypesLinkRepository> {

    protected TypesLinkService(TypesLinkRepository repository) {
        super(repository);
    }

    @Override
    public Long getEntityId(TypesLink typesLink) {
        return typesLink.getId();
    }
}
