package com.nitssrpi.NIT_SRPI.repository.specs;

import com.nitssrpi.NIT_SRPI.model.ApplicationField;
import org.springframework.data.jpa.domain.Specification;

public class ApplicationFieldSpecs {

    public static Specification<ApplicationField> likeDescription(String description){
        return ((root, query, cb) -> cb.like(cb.lower(root.get("description")), "%" + description.toLowerCase() +"%"));
    }

}
