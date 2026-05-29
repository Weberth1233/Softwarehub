package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRoyaltyDistributionRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRoyaltyDistributionResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ProcessRoyaltyDistributionMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.ProcessRoyaltyDistribution;
import com.nitssrpi.NIT_SRPI.service.ProcessRoyaltyDistributionService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/process-royalty-distribution")
@RequiredArgsConstructor
@Tag(name = "Distribuição de cotas do processo")
public class ProcessRoyaltyDistributionController extends GenericController<ProcessRoyaltyDistribution, ProcessRoyaltyDistributionRequestDTO, ProcessRoyaltyDistributionResponseDTO, Long> {
    private final ProcessRoyaltyDistributionService service;
    private final ProcessRoyaltyDistributionMapper mapper;

    @Override
    protected GenericService<ProcessRoyaltyDistribution, Long> getService() {
        return service;
    }

    @Override
    protected GenericMapper<ProcessRoyaltyDistribution, ProcessRoyaltyDistributionRequestDTO, ProcessRoyaltyDistributionResponseDTO> getMapper() {
        return mapper;
    }

    @PatchMapping("/{id}/activate")
    public ResponseEntity<ProcessRoyaltyDistributionResponseDTO> activate(
            @PathVariable Long id
    ) {
        ProcessRoyaltyDistribution activated = service.activateDistribution(id);
        return ResponseEntity.ok(mapper.toDTO(activated));
    }

}
