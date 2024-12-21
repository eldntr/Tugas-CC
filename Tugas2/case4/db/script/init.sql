USE mydb;

ALTER USER 'myuser'@'%' IDENTIFIED WITH mysql_native_password BY 'mypassword';
GRANT ALL PRIVILEGES ON mydb.* TO 'myuser'@'%';

CREATE TABLE IF NOT EXISTS weather (
    timestamp DATETIME NOT NULL PRIMARY KEY,
    city VARCHAR(255) NOT NULL,
    temperature FLOAT NOT NULL,
    description VARCHAR(255)
);
