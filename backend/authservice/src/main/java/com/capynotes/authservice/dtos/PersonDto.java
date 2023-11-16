package com.capynotes.authservice.dtos;

import com.capynotes.authservice.models.Person;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PersonDto {
    public PersonDto(Person person) {
        this.id = person.getId();
        this.name = person.getName();
        this.surname = person.getSurname();
        this.email = person.getEmail();
        this.role = person.getRole();
    }

    private Long id;
    private String name;
    private String surname;
    private String email;
    private String role;
}
