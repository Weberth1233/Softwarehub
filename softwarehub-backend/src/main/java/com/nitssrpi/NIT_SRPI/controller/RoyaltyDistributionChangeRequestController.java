package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.controller.dto.ApproveChangeRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.RejectChangeRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.RoyaltyDistributionChangeRequestRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.RoyaltyDistributionChangeRequestResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.RoyaltyDistributionChangeRequestMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.RoyaltyDistributionChangeRequest;
import com.nitssrpi.NIT_SRPI.service.RoyaltyDistributionChangeRequestService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/royalty-distribution-change-requests")
@RequiredArgsConstructor
@Tag(name = "Alteração na distribuição de cotas do processo")
public class RoyaltyDistributionChangeRequestController extends GenericController<
        RoyaltyDistributionChangeRequest,
        RoyaltyDistributionChangeRequestRequestDTO,
        RoyaltyDistributionChangeRequestResponseDTO, Long> {

    private final RoyaltyDistributionChangeRequestService service;
    private final RoyaltyDistributionChangeRequestMapper mapper;

    @Override
    protected GenericService<RoyaltyDistributionChangeRequest, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<RoyaltyDistributionChangeRequest, RoyaltyDistributionChangeRequestRequestDTO, RoyaltyDistributionChangeRequestResponseDTO> getMapper() {
        return mapper;
    }

    @PatchMapping("/{id}/approve")
    public ResponseEntity<RoyaltyDistributionChangeRequestResponseDTO> approve(
            @PathVariable Long id,
            @RequestBody @Valid ApproveChangeRequestDTO dto
    ) {
        RoyaltyDistributionChangeRequest approved =
                service.approve(id, dto.reviewedById());

        return ResponseEntity.ok(mapper.toDTO(approved));
    }

    @PatchMapping("/{id}/reject")
    public ResponseEntity<RoyaltyDistributionChangeRequestResponseDTO> reject(
            @PathVariable Long id,
            @RequestBody @Valid RejectChangeRequestDTO dto
    ) {
        RoyaltyDistributionChangeRequest rejected =
                service.reject(
                        id,
                        dto.reviewedById(),
                        dto.rejectionReason()
                );

        return ResponseEntity.ok(mapper.toDTO(rejected));
    }


}