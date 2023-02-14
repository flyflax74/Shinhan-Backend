package com.example.tutorialvlt.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "tutorials")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Tutorial {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(name = "title")
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "published")
    private Boolean published;

    public String toString() {
        return "Tutorial [id="+ id + ", title=" + title + ", description="+ description + ", publish=" + published + "]";
    }
}
