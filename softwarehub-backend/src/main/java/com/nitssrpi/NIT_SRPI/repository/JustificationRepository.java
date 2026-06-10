package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.Justification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface JustificationRepository extends JpaRepository<Justification, Long> {
    List<Justification> findByProcessIdOrderByCreatedAtDesc(Long processId);
}
