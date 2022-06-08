CREATE DATABASE IF NOT EXISTS platzi_operation;
SHOW warnings;

CREATE TABLE IF NOT EXISTS authors(
    author_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    nationatily VARCHAR(3)
    );

CREATE TABLE IF NOT EXISTS books (
    book_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    author_id INTEGER UNSIGNED,
    title VARCHAR(100) NOT NULL,
    year INTEGER UNSIGNED NOT NULL DEFAULT 1900,
    language VARCHAR(2) NOT NULL DEFAULT "es" COMMENT "ISO 639-1 Language",
    cover_url VARCHAR(500),
    price DOUBLE(6,2) NOT NULL DEFAULT 10.0,
    sellable TINYINT(1) DEFAULT 1,
    copies INTEGER NOT NULL DEFAULT 1,
    description TEXT
    );
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
    );
    
    
 CREATE TABLE  clients(
   client_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
   `name` VARCHAR(50) NOT NULL,
   email VARCHAR (100) NOT NULL UNIQUE,
   birthdate DATETIME,
   gender ENUM("M,","F","ND")NOT NULL,
   active TINYINT(1) NOT NULL DEFAULT 1,   
   created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   update_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      ON UPDATE CURRENT_TIMESTAMP   
   );
   
   CREATE TABLE IF NOT EXISTS operations(
      operation_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
      book_id  INTEGER UNSIGNED,
      client_id INTEGER UNSIGNED ,
      `type` ENUM( "B","R","S") NOT NULL COMMENT "B=Borrowed,R=Returned, S=Sold" ,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      update_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      finished TINYINT(1) NOT NULL
      );
   
   INSERT INTO  authors (name,nationatily)
   VALUES("Gabril Garcia Marquez", "COL");
   
   INSERT INTO authors (name ,nationatily)
   VALUES("Juan Rulfo", "MEX");
   
   INSERT INTO authors (name ,nationatily)
   VALUES("Juan Gabriel Vasquez", "COL");
   
   
   INSERT INTO clients(client_id,name,email,birthdate,gender,active)VALUES
   (1,"Maria Dolores Gomez","mariadoloresgomez@random.names","1971-06-06","F",1),
        (2,"Adrian Fernandez","adrianfernandez@random.names","1970-04-09","M,",1),
       (3,"Maria Luisa Marin","marialuisamarin@random.names","1957-07-30","F",1),
              (4,"Pedro Sanchez","Pedrosanchez@random.names","1992-01-31","M,",1);
   
   
   INSERT INTO clients(name,email,birthdate,gender,active)VALUES
   ("Pedro Sanchez","Pedrosanchez@random.names","1992-01-31","M,",0)
   ON DUPLICATE KEY UPDATE active =VALUES(active);
   
   
   ---- funcion select 
   
    Listar todas la tuplas de la tabla clients
SELECT * FROM clients;

-- Listar todos los nombres de la tabla clients
SELECT name FROM clients;

-- Listar todos los nombres, email y género de la tabla clients
SELECT name, email, gender FROM clients;

-- Listar los 10 primeros resultados de la tabla clients
SELECT name, email, gender FROM clients LIMIT 10;

-- Listar todos los clientes de género Masculino
SELECT name, email, gender FROM clients WHERE gender = 'M';

-- Listar el año de nacimientos de los clientes, con la función YEAR()
SELECT YEAR(birthdate) FROM clients;

-- Mostrar el año actual
SELECT YEAR(NOW());

-- Listar los 10 primeros resultados de las edades de los clientes
SELECT YEAR(NOW()) - YEAR(birthdate) FROM clients LIMIT 10;

-- Listar nombre y edad de los 10 primeros clientes
SELECT name, YEAR(NOW()) - YEAR(birthdate) FROM clients LIMIT 10;

-- Listar clientes que coincidan con el nombre de "Saave"
SELECT * FROM clients WHERE name LIKE '%Saave%';

-- Listar clientes (nombre, email, edad y género). con filtro de genero = F y nombre que coincida con 'Lop'
--Usando alias para nombrar la función como 'edad'
SELECT name, email, YEAR(NOW()) - YEAR(birthdate) AS edad, gender FROM clients WHERE gender = 'F' AND name LIKE '%Lop%';
   
   
   
    INSERT INTO transactions (book_id, client_id, type, finished) VALUES
    -> (12,34,'sell',1),
    -> (54,87,'lend',0),
    -> (3,14,'sell',1),
    -> (1,54,'sell',1),
    -> (12,81,'lend',1),
    -> (12,81,'sell',1),
    -> (87,29,'sell',1);
   
   
   
    Uso del JOIN implícito
SELECT b.title, a.name
FROM authors AS a, books AS b
WHERE a.author_id = b.author_id
LIMIT 10;

-- Uso del JOIN explícito
SELECT b.title, a.name
FROM books AS b
INNER JOIN authors AS a
  ON a.author_id = b.author_id
LIMIT 10;

--  JOIN y order by (por defecto es ASC)
SELECT a.author_id, a.name, a.nationality, b.title
FROM authors AS a
JOIN books AS b
  ON b.author_id = a.author_id
WHERE a.author_id BETWEEN 1 AND 5
ORDER BY a.author_id DESC;

-- LEFT JOIN para traer datos incluso que no existen, como el caso del author_id = 4 que no tene ningún libro registrado.
SELECT a.author_id, a.name, a.nationality, b.title
FROM authors AS a
LEFT JOIN books AS b
  ON b.author_id = a.author_id
WHERE a.author_id BETWEEN 1 AND 5
ORDER BY a.author_id;

-- Contar número de libros tiene un autor.
-- Con COUNT (contar), es necesario tener un GROUP BY (agrupado por un criterio)
SELECT a.author_id, a.name, a.nationality, COUNT(b.book_id)
FROM authors AS a
LEFT JOIN books AS b
  ON b.author_id = a.author_id
WHERE a.author_id BETWEEN 1 AND 5
GROUP BY a.author_id
ORDER BY a.author_id;


SELECT AVG (price) as prom, STDDEV(price) AS std 
FROM books;


SELECT nationality , AVG (price) as prom,
  STDDEV(price) AS std
  FROM books as b
  JOIN  authors as a 
   ON a.author_id = b.author_id
   GROUP BY  nationality
   ORDER BY  prom DESC;
   
   
SELECT nationality ,
COUNT(book_id) as libros,
 AVG (price) as prom,
  STDDEV(price) AS std
  FROM books as b
  JOIN  authors as a 
   ON a.author_id = b.author_id
   GROUP BY  nationality
   ORDER BY  prom DESC;
   
   SELECT MAX(price), MIN(price)
   FROM books;
   
   SELECT nationality, MAX(price), MIN(price)
   FROM books as b
   JOIN authors AS a
   ON a.author_id = b.author_id
   GROUP BY nationality;
   
   SELECT c.name, t.type, b.title, a.name, a.nationality
   FROM transactions AS t
   LEFT JOIN clients AS c
     ON c .client_id = t.client_id
  LEFT JOIN  books AS b
     ON b.book_id = t.book_id
 LEFT JOIN authors AS a
   ON b.author_id = a.author_id;
   
   SELECT c.name, t.type, b.title,
   CONCAT(a.name, "(",a.nationality,")") AS autor
   FROM transactions AS t
   LEFT JOIN clients AS c
     ON c .client_id = t.client_id
  LEFT JOIN  books AS b
     ON b.book_id = t.book_id
 LEFT JOIN authors AS a
   ON b.author_id = a.author_id;
   
   SELECT c.name, t.type, b.title,
   CONCAT(a.name, "(",a.nationality,")") AS autor,
   TO_DAYS(NOW()) - TO_DAYS(t.created_at) AS ago 
   FROM transactions AS t
   LEFT JOIN clients AS c
     ON c .client_id = t.client_id
  LEFT JOIN  books AS b
     ON b.book_id = t.book_id
 LEFT JOIN authors AS a
   ON b.author_id = a.author_id;
   
   UPDATE tabla
   SET 
   [columna = valor, ...]
   WHERE
   [condiciones]
   LIMIT 1;
   
   UPDATE clients
   SET active = 0 
   WHERE client_id =80
   LIMIT 1;
   
   select client_id, name
   from clients
   WHERE
   client_id IN (1, 6,8,27,90)
   OR name like '%Lopez%'
   
   UPDATE clients
   SET 
     active=0 
   WHERE
      client_id IN (1,6,827,90)
      OR name like  '%Lopez%';
   
    select count(book_id),
    sum(if(year<1950,1,0)) as '<1950', 
    sum(if(year<1950,0,1)) as '>1950'
    from books;
   
   select count(book_id),
    sum(if(year < 1950,1,0)) as '<1950', 
    sum(if(year >= 1950 and year < 1990, 1, 0)) as '<1990',
    sum(if(year >= 2000,1,0 )) as '<hoy'
    from books;
   
   select nationality count(book_id),
    sum(if(year < 1950,1,0)) as '<1950', 
    sum(if(year >= 1950 and year < 1990, 1, 0)) as '<1990',
    sum(if(year >= 2000,1,0 )) as '<hoy'
    from books as b
    join authors as a
     on  a .author_id = b.author_id
     where
     a . nationality is not null
     group by nationality;