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

    @PutMapping("/{id}")
    @Operation(summary = "Atualizar", description = "Atualizar passando o ID como parâmetro")
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Atualizado com sucesso!"),
            @ApiResponse(responseCode = "404", description = "Item não encontrado!"),
    })
    public ResponseEntity<Object> update(
            @PathVariable Long id,
            @RequestBody @Valid ProcessRoyaltyDistributionRequestDTO dto
    ) {
        Optional<ProcessRoyaltyDistribution> optional = service.getById(id);

        if (optional.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        System.out.println("========== TESTE UPDATE DISTRIBUIÇÃO ==========");
        System.out.println("ID recebido na rota: " + id);

        System.out.println(
                "DTO shares: " +
                        (dto.shares() == null ? "null" : dto.shares().size())
        );

        if (dto.shares() != null) {
            dto.shares().forEach(share -> {
                System.out.println("DTO share type: " + share.type());
                System.out.println("DTO share userId: " + share.userId());
                System.out.println("DTO share educationalInstitutionId: " + share.educationalInstitutionId());
                System.out.println("DTO share percentage: " + share.percentage());
                System.out.println("----------------------------------");
            });
        }

        ProcessRoyaltyDistribution entity = mapper.toEntity(dto);
        entity.setId(id);

        System.out.println(
                "ENTITY shares após mapper.toEntity: " +
                        (entity.getShares() == null ? "null" : entity.getShares().size())
        );

        if (entity.getShares() != null) {
            entity.getShares().forEach(share -> {
                System.out.println("ENTITY share type: " + share.getType());
                System.out.println(
                        "ENTITY share userId: " +
                                (share.getUser() == null ? "null" : share.getUser().getId())
                );
                System.out.println(
                        "ENTITY share educationalInstitutionId: " +
                                (share.getEducationalInstitution() == null
                                        ? "null"
                                        : share.getEducationalInstitution().getId())
                );
                System.out.println("ENTITY share percentage: " + share.getPercentage());
                System.out.println("----------------------------------");
            });
        }

        System.out.println("===============================================");

        service.update(entity);

        return ResponseEntity.noContent().build();
    }
}
