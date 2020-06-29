CREATE TABLE creations (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_name VARCHAR(255) NOT NULL
);

INSERT INTO
  creations (id, name, owner_name)
VALUES
  (1, "Scared Green Gecko", "Charles")
