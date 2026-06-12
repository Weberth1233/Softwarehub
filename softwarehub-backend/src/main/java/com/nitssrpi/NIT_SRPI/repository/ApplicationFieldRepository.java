package com.nitssrpi.NIT_SRPI.repository;
import com.nitssrpi.NIT_SRPI.model.ApplicationField;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;
import java.util.Optional;

public interface ApplicationFieldRepository extends JpaRepository<ApplicationField, Long>, JpaSpecificationExecutor<ApplicationField> {
    Optional<ApplicationField> findByCodeIgnoreCase(String code);

    boolean existsByCodeIgnoreCase(String code);

    boolean existsByNameIgnoreCase(String name);

    List<ApplicationField> findDistinctByApplicationArea_IdOrderByCodeAsc(Long processId);}
