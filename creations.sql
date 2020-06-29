CREATE TABLE creations (
  id INTEGER PRIMARY KEY,
  owner_id INTEGER NOT NULL,
  creation_name VARCHAR(255) NOT NULL,
  creation_rating INTEGER,

  FOREIGN KEY (owner_id) REFERENCES owners(id)
);

CREATE TABLE owners (
  id INTEGER PRIMARY KEY,
  owner_name VARCHAR(255) NOT NULL,
  owner_rating INTEGER
);
