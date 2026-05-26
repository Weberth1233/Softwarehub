package com.nitssrpi.NIT_SRPI.repository;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ConsentTermRepository  extends JpaRepository<ConsentTerm, Long> {

    Optional<ConsentTerm> findByIpTypeId(Long ipTypeId);

    boolean existsByIpTypeId(Long ipTypeId);

    boolean existsByIpTypeIdAndIdNot(
            Long ipTypeId,
            Long id
    );
}
