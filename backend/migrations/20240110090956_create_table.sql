-- Add migration script here
CREATE TABLE skill (
    id SERIAL NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    PRIMARY KEY (id) 
);

CREATE TABLE career (
    id SERIAL NOT NULL,
    name TEXT NOT NULL,
    years_from DATE NOT NULL,
    years_to DATE,
    description TEXT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE about (
    id SERIAL NOT NULL,
    description TEXT NOT NULL,
    PRIMARY KEY (id)
);