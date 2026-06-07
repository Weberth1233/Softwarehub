package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.model.NiceClassification;
import com.nitssrpi.NIT_SRPI.repository.NiceClassificationRepository;
import com.nitssrpi.NIT_SRPI.repository.ProcessRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NiceClassificationService {
    private final NiceClassificationRepository repository;
    private final ProcessRepository processRepository;

    public NiceClassification save(NiceClassification niceClassification){
        return repository.save(niceClassification);
    }

    public void update(NiceClassification niceClassification){
        if(niceClassification.getCode() == null){
            throw new EntityNotFoundException("Para atualizar é necessário que o classificação de nice esteja cadastrado!");
        }
        repository.save(niceClassification);
    }

    public Optional<NiceClassification> getById(Integer id){
        return repository.findById(id);
    }

    public void delete(NiceClassification niceClassification) {
        repository.delete(niceClassification);
    }

    public List<NiceClassification> getAll(){
        return repository.findAll();
    }

}
