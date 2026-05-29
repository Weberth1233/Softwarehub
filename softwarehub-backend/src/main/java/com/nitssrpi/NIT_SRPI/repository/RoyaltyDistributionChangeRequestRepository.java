package com.nitssrpi.NIT_SRPI.repository;
import com.nitssrpi.NIT_SRPI.model.RoyaltyDistributionChangeRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import com.nitssrpi.NIT_SRPI.model.ChangeRequestStatus;
import java.util.Optional;

public interface RoyaltyDistributionChangeRequestRepository
        extends JpaRepository<RoyaltyDistributionChangeRequest, Long> {

    boolean existsByProcessIdAndStatus(
            Long processId,
            ChangeRequestStatus status
    );

    Optional<RoyaltyDistributionChangeRequest> findByProcessIdAndStatus(
            Long processId,
            ChangeRequestStatus status
    );
}
