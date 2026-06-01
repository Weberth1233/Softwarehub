package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {

    UserDetails findByEmail(String email);

    boolean existsByCpf(String cpf);
    boolean existsByEmail(String email);

    boolean existsByCpfAndIdNot(
            String cpf,
            Long id
    );

    boolean existsByEmailAndIdNot(
            String email,
            Long id
    );

    @Query("""
    SELECT DISTINCT u
    FROM User u
    LEFT JOIN FETCH u.address
    LEFT JOIN FETCH u.userEducationalInstitutionLinks links
    LEFT JOIN FETCH links.educationalInstitution
    LEFT JOIN FETCH links.typesLink
    WHERE u.id = :id
""")
    Optional<User> findByIdWithRelations(@Param("id") Long id);
}
