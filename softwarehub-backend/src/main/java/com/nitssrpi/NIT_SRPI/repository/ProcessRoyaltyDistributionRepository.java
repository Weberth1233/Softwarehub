package com.nitssrpi.NIT_SRPI.repository;
import com.nitssrpi.NIT_SRPI.model.ProcessRoyaltyDistribution;
import com.nitssrpi.NIT_SRPI.model.RoyaltyDistributionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface ProcessRoyaltyDistributionRepository extends JpaRepository<ProcessRoyaltyDistribution, Long> {
    Optional<ProcessRoyaltyDistribution> findByProcessIdAndStatus(Long processId, RoyaltyDistributionStatus status);
    boolean existsByProcessIdAndStatus(Long processId, RoyaltyDistributionStatus status);
    //serve para buscar a maior versão existente daquele processo.
    Optional<ProcessRoyaltyDistribution> findTopByProcessIdOrderByVersionDesc(
            Long processId
    );
}
