INSERT INTO users(name) VALUES ('admin');

INSERT INTO skill(title, content, userid) VALUES ('Rust', 'Rust programming language (blazingly fast).', 1);
INSERT INTO skill(title, content, userid) VALUES ('Elm', 'Elm programming language (delightful)', 1);

INSERT INTO career(name, years_from, years_to, description, userid) VALUES('XXX university', '2019-04-01', '2021-03-31', 'Went through a moratorium period.', 1);
INSERT INTO career(name, years_from, years_to, description, userid) VALUES('XXX graduate school', '2021-04-01', NULL, 'Majored in computer architecture.', 1);

INSERT INTO about(description, userid) VALUES ('Test about me description from the database!', 1);

INSERT INTO blog(name, content) VALUES ('First Blog Post', 'This is the content of the first blog post.');
INSERT INTO blog(name, content) VALUES ('Second Blog Post', 'Content for the second blog post can be found here.');
