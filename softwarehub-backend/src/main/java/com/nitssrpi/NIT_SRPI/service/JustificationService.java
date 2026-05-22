package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.model.Justification;
import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import com.nitssrpi.NIT_SRPI.repository.JustificationRepository;
import com.nitssrpi.NIT_SRPI.repository.ProcessRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class JustificationService {

    private final JustificationRepository repository;
    private final ProcessRepository processRepository;

    public Justification save(Long processId, String reason) {
        Process process = processRepository.findById(processId)
                .orElseThrow(() -> new EntityNotFoundException("Processo não encontrado"));
        process.setStatus(StatusProcess.CORRECAO);
        Justification justification = new Justification();
        justification.setReason(reason);
        justification.setProcess(process);

        return repository.save(justification);
    }

    public void update(Justification justification){
        if(justification.getId() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que a justificativa esteja cadastrado!");
        }
        repository.save(justification);
    }

    public List<Justification> findByProcessJustification(Long idProcess){
            return  repository.findByProcessId(idProcess);
    }

    public Optional<Justification> getById(Long id){
        return repository.findById(id);
    }

    public void delete(Justification justification){
        repository.delete(justification);
    }
}

