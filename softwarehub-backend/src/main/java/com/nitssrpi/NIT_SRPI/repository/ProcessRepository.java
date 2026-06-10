package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.controller.dto.ProcessStatusCountDTO;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProcessRepository extends JpaRepository<Process, Long>, JpaSpecificationExecutor<Process> {

   /* @Modifying
    @Transactional
    @Query("UPDATE Process p SET p.status = :status WHERE p.id = :id")
    void updateStatus(Long id, StatusProcess status);*/

    @Query("""
            SELECT p.status AS status,
            COUNT(p) AS amount
            FROM Process p
            WHERE p.creator.id = :creatorId
            GROUP BY p.status
           """)
    List<ProcessStatusCountDTO> countProcessStatus(@Param("creatorId") Long id);

    @Query("""
            SELECT p.status AS status,
            COUNT(p) AS amount
            FROM Process p
            WHERE p.status <> 'INATIVO'
            GROUP BY p.status
           """)
    List<ProcessStatusCountDTO> countProcessStatusAdmin();

    Page<Process> findByCreatorId(Long creatorId, Pageable pageable);
}
