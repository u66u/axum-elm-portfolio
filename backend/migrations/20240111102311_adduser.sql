-- Add migration script here
CREATE TABLE users (
    id SERIAL NOT NULL,
    name TEXT NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE skill ADD COLUMN userid INT REFERENCES users(id);
ALTER TABLE about ADD COLUMN userid INT REFERENCES users(id);
ALTER TABLE career ADD COLUMN userid INT REFERENCES users(id);