package io.getarrayus.securecapita.repository;

import java.util.Collection;

import io.getarrayus.securecapita.domain.User;

public interface UserRepository<T extends User> {

    // CRUD Operations
    T create(T data);

    Collection<T> list(int page, int pagesize);

    T get(Long id);

    T update(T data);

    Boolean delete(Long id);
}
