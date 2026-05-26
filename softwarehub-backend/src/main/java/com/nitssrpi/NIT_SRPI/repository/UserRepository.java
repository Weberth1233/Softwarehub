package com.nitssrpi.NIT_SRPI.repository;

import com.nitssrpi.NIT_SRPI.model.Process;
import com.nitssrpi.NIT_SRPI.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.security.core.userdetails.UserDetails;

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
}
