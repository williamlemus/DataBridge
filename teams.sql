CREATE TABLE players (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  team_id INTEGER,

  FOREIGN KEY(team_id) REFERENCES team(id)
);

CREATE TABLE teams (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  city_id INTEGER,

  FOREIGN KEY(city_id) REFERENCES city(id)
);


CREATE TABLE cities (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);


INSERT INTO
  cities(id, name)
VALUES
  (1, 'New York'), (2, 'Los Angeles');

INSERT INTO
  teams (id, name, city_id)
VALUES
  (1, 'Clamoring Statisticians', 1),
  (2, 'Blitzers', 1),
  (3, 'Considerable Rush', 2),
  (4, 'Cityless Team', NULL);

  INSERT INTO
    players (id, fname, lname, team_id)
  VALUES
  (1,'Steven', 'Smith',1),
  (2,'Alice', 'Maurer',2),
  (3,'Morgan', 'Leathers',3),
  (4,'Bruce', 'Delong',4),
  (5,'Brian','Ortiz',1),
  (6,'Jacob','Flanagan',2),
  (7,'Anthony', 'Voss',3),
  (8,'Gilbert', 'Miller',4),
  (9,'Felicia', 'Jackman',1),
  (10,'Kenneth', 'Foster',2),
  (11,'Raymond', 'McGhee',3),
  (12,'Rachel', 'Stewart',4),
  (13,'Cheryl', 'Toomey',4),
  (14, 'Free', 'Agent', NULL);
