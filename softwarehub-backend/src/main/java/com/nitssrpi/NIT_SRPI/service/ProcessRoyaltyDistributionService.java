package com.nitssrpi.NIT_SRPI.service;

import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.controller.exceptions.OperationNotAllowedException;
import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.*;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.repository.ProcessRepository;
import com.nitssrpi.NIT_SRPI.repository.ProcessRoyaltyDistributionRepository;
import com.nitssrpi.NIT_SRPI.repository.RoyaltyDistributionChangeRequestRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Service
public class ProcessRoyaltyDistributionService extends GenericServiceImpl<
        ProcessRoyaltyDistribution,
        Long,
        ProcessRoyaltyDistributionRepository> {

    private static final BigDecimal TOTAL_PERCENTAGE = new BigDecimal("100.00");
    private static final BigDecimal MIN_CREATOR_PERCENTAGE = new BigDecimal("5.00");

    private final ProcessRepository processRepository;
    private final RoyaltyDistributionChangeRequestRepository changeRequestRepository;

    public ProcessRoyaltyDistributionService(
            ProcessRoyaltyDistributionRepository repository,
            ProcessRepository processRepository,
            RoyaltyDistributionChangeRequestRepository changeRequestRepository
    ) {
        super(repository);
        this.processRepository = processRepository;
        this.changeRequestRepository = changeRequestRepository;
    }

    @Transactional
    public ProcessRoyaltyDistribution save(ProcessRoyaltyDistribution distribution) {

        validateProcess(distribution);

        Long processId = distribution.getProcess().getId();

        Process process = processRepository.findById(processId)
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado."));

        distribution.setProcess(process);

        boolean isInitialDistribution = distribution.getChangeRequest() == null ||
                distribution.getChangeRequest().getId() == null;

        if (isInitialDistribution) {
            validateCanCreateInitialDistribution(process);
        } else {
            validateCanCreateDistributionFromChangeRequest(process);
        }

        Integer nextVersion = getNextVersion(processId);
        distribution.setVersion(nextVersion);

        if (isInitialDistribution) {
            prepareInitialDistribution(distribution, processId);
        } else {
            prepareDistributionFromApprovedChangeRequest(distribution);
        }

        validateDistribution(distribution);
        validateSharesParticipants(distribution, process);
        bindSharesToDistribution(distribution);

        process.setStatus(StatusProcess.COTAS_DISTRIBUIDAS);

        return repository.save(distribution);
    }

    @Override
    public Long getEntityId(ProcessRoyaltyDistribution processRoyaltyDistribution) {
        return processRoyaltyDistribution.getId();
    }

    public ProcessRoyaltyDistribution getActiveByProcessId(Long processId) {
        return repository.findByProcessIdAndStatus(
                processId,
                RoyaltyDistributionStatus.ACTIVE
        ).orElseThrow(() ->
                new EntityNotFoundException("Distribuição ativa não encontrada para esse processo.")
        );
    }

    @Transactional
    public ProcessRoyaltyDistribution activateDistribution(Long distributionId) {

        ProcessRoyaltyDistribution newDistribution = repository.findById(distributionId)
                .orElseThrow(() ->
                        new EntityNotFoundException("Distribuição de cotas não encontrada.")
                );

        if (newDistribution.getStatus() == RoyaltyDistributionStatus.ACTIVE) {
            throw new DuplicateRecordException("Essa distribuição já está ativa.");
        }

        Process process = newDistribution.getProcess();

        validateCanActivateDistribution(process);

        validateDistribution(newDistribution);
        validateSharesParticipants(newDistribution, process);

        ProcessRoyaltyDistribution activeDistribution =
                repository.findByProcessIdAndStatus(
                        process.getId(),
                        RoyaltyDistributionStatus.ACTIVE
                ).orElse(null);

        if (activeDistribution != null) {
            activeDistribution.setStatus(RoyaltyDistributionStatus.INACTIVE);
            repository.save(activeDistribution);
        }

        newDistribution.setStatus(RoyaltyDistributionStatus.ACTIVE);

        /*
         * Ao ativar uma nova distribuição, o processo continua/volta
         * para cotas distribuídas, aguardando análise/classificação.
         */
        process.setStatus(StatusProcess.COTAS_DISTRIBUIDAS);

        return repository.save(newDistribution);
    }

    private void prepareInitialDistribution(
            ProcessRoyaltyDistribution distribution,
            Long processId
    ) {
        validateProcessDoesNotHaveActiveDistribution(processId);

        distribution.setStatus(RoyaltyDistributionStatus.ACTIVE);
        distribution.setChangeRequest(null);
    }

    private void prepareDistributionFromApprovedChangeRequest(
            ProcessRoyaltyDistribution distribution
    ) {
        Long changeRequestId = distribution.getChangeRequest().getId();

        RoyaltyDistributionChangeRequest changeRequest =
                changeRequestRepository.findById(changeRequestId)
                        .orElseThrow(() ->
                                new EntityNotFoundException("Solicitação de alteração não encontrada.")
                        );

        if (changeRequest.getStatus() != ChangeRequestStatus.APPROVED) {
            throw new IllegalArgumentException(
                    "A solicitação de alteração precisa estar aprovada para gerar uma nova distribuição."
            );
        }

        Long distributionProcessId = distribution.getProcess().getId();
        Long changeRequestProcessId = changeRequest.getProcess().getId();

        if (!distributionProcessId.equals(changeRequestProcessId)) {
            throw new IllegalArgumentException(
                    "A solicitação de alteração não pertence ao processo informado."
            );
        }

        distribution.setChangeRequest(changeRequest);
        distribution.setStatus(RoyaltyDistributionStatus.DRAFT);
    }

    private Integer getNextVersion(Long processId) {
        return repository.findTopByProcessIdOrderByVersionDesc(processId)
                .map(lastDistribution -> lastDistribution.getVersion() + 1)
                .orElse(1);
    }

    private void validateCanCreateInitialDistribution(Process process) {
        if (process.getStatus() == StatusProcess.FINALIZADO) {
            throw new OperationNotAllowedException(
                    "Processo finalizado não permite distribuição de cotas."
            );
        }
        if (process.getStatus() == StatusProcess.INATIVO) {
            throw new OperationNotAllowedException(
                    "Processo inativo não permite distribuição de cotas."
            );
        }
        if (process.getStatus() == StatusProcess.CORRECAO) {
            throw new OperationNotAllowedException(
                    "Processo em correção não permite distribuição de cotas antes de ser corrigido."
            );
        }
        if (process.getStatus() == StatusProcess.CLASSIFICADO) {
            throw new OperationNotAllowedException(
                    "Processo classificado não permite nova distribuição inicial de cotas."
            );
        }
        if (process.getStatus() == StatusProcess.COTAS_DISTRIBUIDAS) {
            throw new OperationNotAllowedException(
                    "Esse processo já possui cotas distribuídas."
            );
        }
        boolean statusPermitido =
                process.getStatus() == StatusProcess.PENDENTE_DISTRIBUICAO_COTAS ||
                        process.getStatus() == StatusProcess.CORRIGIDO;
        if (!statusPermitido) {
            throw new OperationNotAllowedException(
                    "A distribuição inicial de cotas só pode ser realizada quando o processo estiver aguardando distribuição de cotas ou corrigido."
            );
        }
    }

    private void validateCanCreateDistributionFromChangeRequest(Process process) {
        if (process.getStatus() == StatusProcess.FINALIZADO) {
            throw new OperationNotAllowedException(
                    "Processo finalizado não permite alteração de distribuição de cotas."
            );
        }

        if (process.getStatus() == StatusProcess.INATIVO) {
            throw new OperationNotAllowedException(
                    "Processo inativo não permite alteração de distribuição de cotas."
            );
        }

        if (process.getStatus() == StatusProcess.CORRECAO) {
            throw new OperationNotAllowedException(
                    "Processo em correção não permite alteração de cotas antes de ser corrigido."
            );
        }

        if (process.getStatus() == StatusProcess.PENDENTE_DISTRIBUICAO_COTAS) {
            throw new OperationNotAllowedException(
                    "O processo ainda não possui distribuição de cotas ativa para ser alterada."
            );
        }
    }

    private void validateCanActivateDistribution(Process process) {
        if (process == null || process.getId() == null) {
            throw new IllegalArgumentException("A distribuição não possui processo vinculado.");
        }

        if (process.getStatus() == StatusProcess.FINALIZADO) {
            throw new OperationNotAllowedException(
                    "Processo finalizado não permite ativar nova distribuição de cotas."
            );
        }

        if (process.getStatus() == StatusProcess.INATIVO) {
            throw new OperationNotAllowedException(
                    "Processo inativo não permite ativar nova distribuição de cotas."
            );
        }

        if (process.getStatus() == StatusProcess.CORRECAO) {
            throw new OperationNotAllowedException(
                    "Processo em correção não permite ativar nova distribuição de cotas."
            );
        }
    }

    private void validateProcess(ProcessRoyaltyDistribution distribution) {
        if (distribution.getProcess() == null ||
                distribution.getProcess().getId() == null) {
            throw new IllegalArgumentException("O processo é obrigatório.");
        }
    }

    private void validateProcessDoesNotHaveActiveDistribution(Long processId) {
        boolean alreadyHasActiveDistribution =
                repository.existsByProcessIdAndStatus(
                        processId,
                        RoyaltyDistributionStatus.ACTIVE
                );

        if (alreadyHasActiveDistribution) {
            throw new DuplicateRecordException(
                    "Esse processo já possui uma distribuição de cotas ativa."
            );
        }
    }

    private void validateDistribution(ProcessRoyaltyDistribution distribution) {

        if (distribution.getShares() == null || distribution.getShares().isEmpty()) {
            throw new IllegalArgumentException("A distribuição precisa ter cotas informadas.");
        }

        validateTotalPercentage(distribution);
        validateUniversityShare(distribution);
        validateCreatorShare(distribution);
        validateNoDuplicateUsers(distribution);
    }

    private void validateTotalPercentage(ProcessRoyaltyDistribution distribution) {

        BigDecimal total = distribution.getShares()
                .stream()
                .map(RoyaltyShare::getPercentage)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (total.compareTo(TOTAL_PERCENTAGE) != 0) {
            throw new IllegalArgumentException(
                    "A soma das cotas deve ser exatamente 100%."
            );
        }
    }

    private void validateUniversityShare(ProcessRoyaltyDistribution distribution) {

        long universityShares = distribution.getShares()
                .stream()
                .filter(share -> share.getType() == RoyaltyShareType.UNIVERSITY)
                .count();

        if (universityShares != 1) {
            throw new IllegalArgumentException(
                    "A distribuição deve possuir exatamente uma cota da universidade."
            );
        }
    }

    private void validateCreatorShare(ProcessRoyaltyDistribution distribution) {

        long creatorShares = distribution.getShares()
                .stream()
                .filter(share -> share.getType() == RoyaltyShareType.CREATOR)
                .count();

        if (creatorShares != 1) {
            throw new IllegalArgumentException(
                    "A distribuição deve possuir exatamente uma cota para o criador."
            );
        }

        RoyaltyShare creatorShare = distribution.getShares()
                .stream()
                .filter(share -> share.getType() == RoyaltyShareType.CREATOR)
                .findFirst()
                .orElseThrow();

        if (creatorShare.getPercentage() == null) {
            throw new IllegalArgumentException("O percentual do criador é obrigatório.");
        }

        if (creatorShare.getPercentage().compareTo(MIN_CREATOR_PERCENTAGE) < 0) {
            throw new IllegalArgumentException(
                    "O criador deve possuir no mínimo 5% da cota."
            );
        }
    }

    private void validateNoDuplicateUsers(ProcessRoyaltyDistribution distribution) {
        Set<Long> userIds = new HashSet<>();

        for (RoyaltyShare share : distribution.getShares()) {
            if (share.getUser() == null || share.getUser().getId() == null) {
                continue;
            }

            Long userId = share.getUser().getId();

            if (!userIds.add(userId)) {
                throw new IllegalArgumentException(
                        "O usuário com ID " + userId + " foi informado mais de uma vez na distribuição de cotas."
                );
            }
        }
    }

    private void validateSharesParticipants(
            ProcessRoyaltyDistribution distribution,
            Process process
    ) {
        for (RoyaltyShare share : distribution.getShares()) {
            validateShareParticipant(share, process);
        }
    }

    private void validateShareParticipant(
            RoyaltyShare share,
            Process process
    ) {
        if (share.getType() == null) {
            throw new IllegalArgumentException("O tipo da cota é obrigatório.");
        }

        switch (share.getType()) {
            case CREATOR -> validateCreatorShareUser(share, process);
            case MEMBER -> validateMemberShareUser(share, process);
            case UNIVERSITY -> validateUniversityShareInstitution(share);
        }
    }

    private void validateCreatorShareUser(
            RoyaltyShare share,
            Process process
    ) {
        if (share.getUser() == null || share.getUser().getId() == null) {
            throw new IllegalArgumentException("O usuário criador da cota é obrigatório.");
        }

        if (process.getCreator() == null || process.getCreator().getId() == null) {
            throw new IllegalArgumentException("O processo não possui criador vinculado.");
        }

        Long creatorIdFromShare = share.getUser().getId();
        Long processCreatorId = process.getCreator().getId();

        if (!Objects.equals(creatorIdFromShare, processCreatorId)) {
            throw new IllegalArgumentException(
                    "O criador informado na distribuição de cotas não é o mesmo criador do processo."
            );
        }
    }

    private void validateMemberShareUser(
            RoyaltyShare share,
            Process process
    ) {
        if (share.getUser() == null || share.getUser().getId() == null) {
            throw new IllegalArgumentException("O usuário membro da cota é obrigatório.");
        }

        Long memberIdFromShare = share.getUser().getId();

        if (process.getCreator() != null &&
                Objects.equals(memberIdFromShare, process.getCreator().getId())) {
            throw new IllegalArgumentException(
                    "O criador do processo deve ser informado como CREATOR, não como MEMBER."
            );
        }

        boolean memberBelongsToProcess = process.getAuthors()
                .stream()
                .anyMatch(author -> Objects.equals(author.getId(), memberIdFromShare));

        if (!memberBelongsToProcess) {
            throw new IllegalArgumentException(
                    "O membro informado não está vinculado ao projeto: " + process.getTitle() + "."
            );
        }
    }

    private void validateUniversityShareInstitution(RoyaltyShare share) {
        if (share.getEducationalInstitution() == null ||
                share.getEducationalInstitution().getId() == null) {
            throw new IllegalArgumentException("A instituição de ensino da cota é obrigatória.");
        }

        if (share.getUser() != null && share.getUser().getId() != null) {
            throw new IllegalArgumentException(
                    "Cota do tipo UNIVERSITY não deve possuir usuário vinculado."
            );
        }
    }

    private void bindSharesToDistribution(ProcessRoyaltyDistribution distribution) {
        for (RoyaltyShare share : distribution.getShares()) {
            share.setDistribution(distribution);
        }
    }
}