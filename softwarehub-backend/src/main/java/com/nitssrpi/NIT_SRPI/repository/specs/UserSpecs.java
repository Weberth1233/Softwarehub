package com.nitssrpi.NIT_SRPI.repository.specs;

import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import com.nitssrpi.NIT_SRPI.model.User;
import org.springframework.data.jpa.domain.Specification;

public class UserSpecs {

    public static Specification<User> notEqualCreatorId(Long creatorId) {
        return (root, query, cb) -> {
            // Assumindo que sua entidade Process tem um atributo 'creator' que é um User
            // Se for apenas um Long chamado 'creatorId', use root.get("creatorId")
            return cb.notEqual(root.get("id"), creatorId);
        };
    }

    public static Specification<User> likeFullName(String fullName){
        return (root, query, cb) -> cb.like(cb.upper(root.get("fullName")), "%" + fullName.toUpperCase() + "%");
    }

    public static Specification<User> likeEmail(String email){
        return (root, query, cb) -> cb.like(cb.upper(root.get("email")), "%" + email.toUpperCase() + "%");
    }

    public static Specification<User> equalCPF(String cpf){
        return (root, query, cb) -> cb.equal(root.get("cpf"), cpf);
    }

}
