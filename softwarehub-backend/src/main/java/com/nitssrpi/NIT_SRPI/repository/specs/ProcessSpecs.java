package com.nitssrpi.NIT_SRPI.repository.specs;

import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.StatusProcess;
import com.nitssrpi.NIT_SRPI.model.User;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import org.springframework.data.jpa.domain.Specification;

public class ProcessSpecs {

    public static Specification<Process> creatorOrAuthor(Long userId) {
        return (root, query, cb) -> {
            query.distinct(true);

            Join<Process, User> authorsJoin = root.join("authors", JoinType.LEFT);

            return cb.or(
                    cb.equal(root.get("creator").get("id"), userId),
                    cb.equal(authorsJoin.get("id"), userId)
            );
        };
    }

    public static Specification<Process> likeTitle(String title){
        return (root, query, cb) -> cb.like(cb.upper(root.get("title")), "%" + title.toUpperCase() + "%");
    }

    public static Specification<Process> equalStatusProcess(StatusProcess status){
        return (root, query, cb) -> cb.equal(root.get("status"), status);
    }

    public static Specification<Process> equalCreatorId(Long creatorId) {
        return (root, query, cb) -> {
            // Assumindo que sua entidade Process tem um atributo 'creator' que é um User
            // Se for apenas um Long chamado 'creatorId', use root.get("creatorId")
            return cb.equal(root.get("creator").get("id"), creatorId);
        };
    }
}
