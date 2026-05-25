package com.nitssrpi.NIT_SRPI.service;
import com.nitssrpi.NIT_SRPI.controller.exceptions.DuplicateRecordException;
import com.nitssrpi.NIT_SRPI.generic.service.GenericServiceImpl;
import com.nitssrpi.NIT_SRPI.model.EducationalInstitution;
import com.nitssrpi.NIT_SRPI.repository.EducationalInstitutionRepository;
import org.springframework.stereotype.Service;

@Service
public class EducationalInstitutionService extends
        GenericServiceImpl<
                EducationalInstitution,
                Long,
                EducationalInstitutionRepository> {

    public EducationalInstitutionService(
            EducationalInstitutionRepository repository
    ) {
        super(repository);
    }

    @Override
    public Long getEntityId(
            EducationalInstitution entity
    ) {
        return entity.getId();
    }

    @Override
    public EducationalInstitution save(
            EducationalInstitution institution
    ) {

        normalizeCnpj(institution);

        validateDuplicateCnpj(
                institution.getCnpj()
        );

        return super.save(institution);
    }

    @Override
    public EducationalInstitution update(
            EducationalInstitution institution
    ) {

        normalizeCnpj(institution);

        validateDuplicateCnpjForUpdate(
                institution.getCnpj(),
                institution.getId()
        );

        return super.update(institution);
    }

    private void normalizeCnpj(
            EducationalInstitution institution
    ) {

        String normalized =
                institution.getCnpj()
                        .replaceAll("\\D", "");

        institution.setCnpj(normalized);
    }

    private void validateDuplicateCnpj(
            String cnpj
    ) {

        if (repository.existsByCnpj(cnpj)) {

            throw new DuplicateRecordException(
                    "O CNPJ informado já está cadastrado no sistema."
            );
        }
    }

    private void validateDuplicateCnpjForUpdate(
            String cnpj,
            Long id
    ) {

        if (repository.existsByCnpjAndIdNot(cnpj, id)) {

            throw new DuplicateRecordException(
                    "O CNPJ informado já está cadastrado no sistema."
            );
        }
    }
}