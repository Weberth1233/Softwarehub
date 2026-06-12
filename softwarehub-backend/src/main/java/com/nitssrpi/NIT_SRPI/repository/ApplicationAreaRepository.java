package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.ApplicationArea;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ApplicationAreaRepository extends JpaRepository<ApplicationArea, Long> {
    Optional<ApplicationArea> findByCodeIgnoreCase(String code);

    boolean existsByCodeIgnoreCase(String code);

    boolean existsByNameIgnoreCase(String name);

    List<ApplicationArea> findAllByOrderByNameAsc();
}
