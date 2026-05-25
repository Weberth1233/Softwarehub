package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.EducationalInstitution;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EducationalInstitutionRepository extends JpaRepository<EducationalInstitution, Long> {
    boolean existsByCnpj(String cnpj);
    List<EducationalInstitution> findByActiveTrue();

    boolean existsByCnpjAndIdNot(
            String cnpj,
            Long id
    );
}
