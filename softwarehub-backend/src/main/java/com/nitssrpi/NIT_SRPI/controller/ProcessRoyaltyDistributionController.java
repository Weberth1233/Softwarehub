package com.nitssrpi.NIT_SRPI.controller;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRoyaltyDistributionRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ProcessRoyaltyDistributionResponseDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.TypesLinkRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.mappers.ProcessRoyaltyDistributionMapper;
import com.nitssrpi.NIT_SRPI.generic.controller.GenericController;
import com.nitssrpi.NIT_SRPI.generic.mapper.GenericMapper;
import com.nitssrpi.NIT_SRPI.generic.service.GenericService;
import com.nitssrpi.NIT_SRPI.model.ProcessRoyaltyDistribution;
import com.nitssrpi.NIT_SRPI.model.TypesLink;
import com.nitssrpi.NIT_SRPI.service.ProcessRoyaltyDistributionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

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

    @Override
    public ResponseEntity<Object> save(ProcessRoyaltyDistributionRequestDTO processRoyaltyDistributionRequestDTO) {
        return super.save(processRoyaltyDistributionRequestDTO);
    }

    @PutMapping("{id}")
    @Operation(summary = "Atualizar", description = "Atualizar passando o ID como paramêtro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Item não encontrado!"),
    })
    public ResponseEntity<Object> update(
            @PathVariable Long id,
            @RequestBody @Valid ProcessRoyaltyDistributionRequestDTO dto
    ) {
        Optional<ProcessRoyaltyDistribution> optional =
                service.getById(id);
        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        ProcessRoyaltyDistribution entity = optional.get();
        mapper.updateEntity(dto,entity);
        service.update(entity);
        return ResponseEntity.noContent().build();
    }
}
