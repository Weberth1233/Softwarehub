package com.nitssrpi.NIT_SRPI.controller.mappers;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermRequestDTO;
import com.nitssrpi.NIT_SRPI.controller.dto.ConsentTermResponseDTO;
import com.nitssrpi.NIT_SRPI.model.ConsentTerm;
import com.nitssrpi.NIT_SRPI.model.IpTypes;
import com.nitssrpi.NIT_SRPI.repository.IpTypesRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper(componentModel = "spring")
public abstract class ConsentTermMapper {

    @Mapping(target = "ipType", source = "ipTypeId")
    public abstract ConsentTerm toEntity(ConsentTermRequestDTO dto);

    public abstract ConsentTermResponseDTO toDTO(ConsentTerm consentTerm);

    protected IpTypes map(Long id) {
        if (id == null) {
            return null;
        }

        IpTypes ipType = new IpTypes();
        ipType.setId(id);

        return ipType;
    }
}