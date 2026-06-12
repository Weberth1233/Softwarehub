package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.controller.dto.ApplicationAreaResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.ApplicationArea;
import com.nitssrpi.NIT_SRPI.model.ApplicationField;
import com.nitssrpi.NIT_SRPI.repository.ApplicationAreaRepository;
import com.nitssrpi.NIT_SRPI.repository.ApplicationFieldRepository;
import com.nitssrpi.NIT_SRPI.repository.specs.ApplicationFieldSpecs;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ApplicationFieldService extends GenericServiceImpl<ApplicationField, Long, ApplicationFieldRepository> {
    private final ApplicationAreaRepository applicationAreaRepository;

    public ApplicationFieldService(ApplicationFieldRepository repository, ApplicationAreaRepository applicationAreaRepository) {
        super(repository);
        this.applicationAreaRepository = applicationAreaRepository;
    }

    @Override
    public ApplicationField save(ApplicationField applicationField) {
        if (repository.existsByCodeIgnoreCase(applicationField.getCode())) {
            throw new DuplicateRecordException("Já existe um campo de aplicação com esse código.");
        }

        Long applicationAreaId = applicationField.getApplicationArea().getId();

        ApplicationArea applicationArea = applicationAreaRepository.findById(applicationAreaId)
                .orElseThrow(() -> new EntityNotFoundException("Área de aplicação não encontrada."));

        applicationField.setCode(applicationField.getCode().trim().toUpperCase());
        applicationField.setName(applicationField.getName().trim());

        if (applicationField.getDescription() != null) {
            applicationField.setDescription(applicationField.getDescription().trim());
        }

        applicationField.setApplicationArea(applicationArea);
        return super.save(applicationField);
    }

    public List<ApplicationField> findByApplicationAreaId(Long applicationAreaId) {
        return repository.findDistinctByApplicationArea_IdOrderByCodeAsc(applicationAreaId);
    }

    @Override
    public Long getEntityId(ApplicationField applicationField) {
        return applicationField.getId();
    }

    @Transactional()
    public Page<ApplicationField> searchApplicationField(String description, Integer page, Integer pageSize){
        Specification<ApplicationField> specs =
                Specification.where((root, query, cb) -> cb.conjunction());
        if(description != null && !description.isEmpty()){
            specs = specs.and(ApplicationFieldSpecs.likeDescription(description));
        }

        Pageable pageRequest = PageRequest.of(page, pageSize, Sort.by(Sort.Direction.ASC, "code"));
        return repository.findAll(specs, pageRequest);

    }
}
