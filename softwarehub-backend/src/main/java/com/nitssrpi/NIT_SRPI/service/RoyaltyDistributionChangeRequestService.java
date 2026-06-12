package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.*;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
public class RoyaltyDistributionChangeRequestService extends GenericServiceImpl<
        RoyaltyDistributionChangeRequest,
        Long,
        RoyaltyDistributionChangeRequestRepository> {

    private final ProcessRepository processRepository;
    private final ProcessRoyaltyDistributionService distributionService;
    private final UserRepository userRepository;
    private final ChangeRequestAttachmentRepository changeRequestAttachmentRepository;

    public RoyaltyDistributionChangeRequestService(
            RoyaltyDistributionChangeRequestRepository repository,
            ProcessRepository processRepository,
            ProcessRoyaltyDistributionService distributionService,
            UserRepository userRepository,
            ChangeRequestAttachmentRepository changeRequestAttachmentRepository
    ) {
        super(repository);
        this.processRepository = processRepository;
        this.distributionService = distributionService;
        this.userRepository = userRepository;
        this.changeRequestAttachmentRepository = changeRequestAttachmentRepository;
    }

    @Transactional
    public RoyaltyDistributionChangeRequest save(RoyaltyDistributionChangeRequest changeRequest) {
        validateProcess(changeRequest);
        validateRequestedBy(changeRequest);
        validateRequestedPercentage(changeRequest);
        validateJustification(changeRequest);
        validateAttachment(changeRequest);
        Long processId = changeRequest.getProcess().getId();
        Long requestedById = changeRequest.getRequestedBy().getId();
        Long attachmentId = changeRequest.getAttachment().getId();

        validateNoPendingRequest(changeRequest);
        Process process = processRepository.findById(processId)
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado."));
        validateCanCreateChangeRequest(process);
        User requestedBy = userRepository.findById(requestedById)
                .orElseThrow(() -> new EntityNotFoundException("Usuário solicitante não encontrado."));
        ChangeRequestAttachment attachment = changeRequestAttachmentRepository.findById(attachmentId)
                .orElseThrow(() -> new EntityNotFoundException("Anexo da solicitação não encontrado."));
        BigDecimal currentUniversityPercentage = getCurrentUniversityPercentage(process.getId());
        if (currentUniversityPercentage.compareTo(changeRequest.getRequestedUniversityPercentage()) == 0) {
            throw new IllegalArgumentException(
                    "O novo percentual da universidade deve ser diferente do percentual atual."
            );
        }
        changeRequest.setProcess(process);
        changeRequest.setRequestedBy(requestedBy);
        changeRequest.setAttachment(attachment);
        changeRequest.setCurrentUniversityPercentage(currentUniversityPercentage);
        changeRequest.setStatus(ChangeRequestStatus.PENDING);
        changeRequest.setReviewedBy(null);
        changeRequest.setReviewedAt(null);
        changeRequest.setRejectionReason(null);
        process.setStatus(StatusProcess.COTAS_DISTRIBUIDAS);
        processRepository.save(process);

        return repository.save(changeRequest);
    }

    @Transactional
    public RoyaltyDistributionChangeRequest approve(
            Long changeRequestId,
            Long reviewedById
    ) {
        RoyaltyDistributionChangeRequest changeRequest =
                getPendingChangeRequest(changeRequestId);
        User reviewedBy = userRepository.findById(reviewedById)
                .orElseThrow(() ->
                        new EntityNotFoundException("Usuário responsável pela análise não encontrado.")
                );
        changeRequest.setStatus(ChangeRequestStatus.APPROVED);
        changeRequest.setReviewedBy(reviewedBy);
        changeRequest.setReviewedAt(LocalDateTime.now());
        changeRequest.setRejectionReason(null);
        return repository.save(changeRequest);
    }

    @Transactional
    public RoyaltyDistributionChangeRequest reject(
            Long changeRequestId,
            Long reviewedById,
            String rejectionReason
    ) {
        RoyaltyDistributionChangeRequest changeRequest =
                getPendingChangeRequest(changeRequestId);

        User reviewedBy = userRepository.findById(reviewedById)
                .orElseThrow(() ->
                        new EntityNotFoundException("Usuário responsável pela análise não encontrado.")
                );

        if (rejectionReason == null || rejectionReason.isBlank()) {
            throw new IllegalArgumentException("O motivo da rejeição é obrigatório.");
        }

        changeRequest.setStatus(ChangeRequestStatus.REJECTED);
        changeRequest.setReviewedBy(reviewedBy);
        changeRequest.setReviewedAt(LocalDateTime.now());
        changeRequest.setRejectionReason(rejectionReason);

        return repository.save(changeRequest);
    }

    @Override
    public Long getEntityId(RoyaltyDistributionChangeRequest entity) {
        return entity.getId();
    }

    private RoyaltyDistributionChangeRequest getPendingChangeRequest(Long id) {
        RoyaltyDistributionChangeRequest changeRequest = repository.findById(id)
                .orElseThrow(() ->
                        new EntityNotFoundException("Solicitação de alteração não encontrada.")
                );

        if (changeRequest.getStatus() != ChangeRequestStatus.PENDING) {
            throw new IllegalArgumentException(
                    "A solicitação de alteração precisa estar pendente para ser analisada."
            );
        }

        return changeRequest;
    }

    private BigDecimal getCurrentUniversityPercentage(Long processId) {
        ProcessRoyaltyDistribution activeDistribution =
                distributionService.getActiveByProcessId(processId);

        return activeDistribution.getShares()
                .stream()
                .filter(share -> share.getType() == RoyaltyShareType.UNIVERSITY)
                .map(RoyaltyShare::getPercentage)
                .findFirst()
                .orElseThrow(() ->
                        new EntityNotFoundException(
                                "Cota atual da universidade não encontrada na distribuição ativa."
                        )
                );
    }

    private void validateProcess(RoyaltyDistributionChangeRequest changeRequest) {
        if (changeRequest.getProcess() == null ||
                changeRequest.getProcess().getId() == null) {
            throw new IllegalArgumentException("O processo é obrigatório.");
        }
    }

    private void validateRequestedBy(RoyaltyDistributionChangeRequest changeRequest) {
        if (changeRequest.getRequestedBy() == null ||
                changeRequest.getRequestedBy().getId() == null) {
            throw new IllegalArgumentException("O usuário solicitante é obrigatório.");
        }
    }

    private void validateRequestedPercentage(RoyaltyDistributionChangeRequest changeRequest) {
        if (changeRequest.getRequestedUniversityPercentage() == null) {
            throw new IllegalArgumentException("O novo percentual da universidade é obrigatório.");
        }

        if (changeRequest.getRequestedUniversityPercentage().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("O percentual da universidade deve ser maior que zero.");
        }

        if (changeRequest.getRequestedUniversityPercentage().compareTo(new BigDecimal("100.00")) >= 0) {
            throw new IllegalArgumentException("O percentual da universidade deve ser menor que 100%.");
        }
    }

    private void validateJustification(RoyaltyDistributionChangeRequest changeRequest) {
        if (changeRequest.getJustification() == null ||
                changeRequest.getJustification().isBlank()) {
            throw new IllegalArgumentException("A justificativa da alteração é obrigatória.");
        }
    }

    private void validateAttachment(RoyaltyDistributionChangeRequest changeRequest) {
        if (changeRequest.getAttachment() == null ||
                changeRequest.getAttachment().getId() == null) {
            throw new IllegalArgumentException("O anexo da solicitação é obrigatório.");
        }
    }

    private void validateNoPendingRequest(RoyaltyDistributionChangeRequest changeRequest) {
        Long processId = changeRequest.getProcess().getId();

        boolean hasPendingRequest =
                repository.existsByProcessIdAndStatus(
                        processId,
                        ChangeRequestStatus.PENDING
                );

        if (hasPendingRequest) {
            throw new DuplicateRecordException(
                    "Já existe uma solicitação de alteração pendente para esse processo."
            );
        }
    }

    private void validateCanCreateChangeRequest(Process process) {
        if (process.getStatus() == StatusProcess.FINALIZADO) {
            throw new IllegalArgumentException(
                    "Não é possível criar solicitação de alteração para um processo finalizado."
            );
        }

        if (process.getStatus() == StatusProcess.INATIVO) {
            throw new IllegalArgumentException(
                    "Não é possível criar solicitação de alteração para um processo inativo."
            );
        }

        if (process.getStatus() == StatusProcess.CORRECAO) {
            throw new IllegalArgumentException(
                    "O processo está em correção. Finalize a correção antes de solicitar alteração de cotas."
            );
        }

        if (process.getStatus() == StatusProcess.PENDENTE_DISTRIBUICAO_COTAS) {
            throw new IllegalArgumentException(
                    "O processo ainda não possui distribuição de cotas para ser alterada."
            );
        }
    }
}