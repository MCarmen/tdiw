#!/bin/bash
set -e

cat <<EOF > Dockerfile
FROM php:7.2-apache

RUN apt-get update

# Install Postgre PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql
EOF

docker build -t apache-php-pdo_pgsql .

docker run -d --name p4-php --network="host" -v "$PWD":/var/www/html apache-php-pdo_pgsql:latest

docker run --name p4-db -p 5432:5432 -e POSTGRES_USER=david -e POSTGRES_DB=myDB -e POSTGRES_PASSWORD=password -d postgres

sleep 10

export PGPASSWORD=password

psql -v ON_ERROR_STOP=1 -U david -h localhost -w myDB <<-EOSQL
	CREATE TABLE graus (id SERIAL PRIMARY KEY, nom VARCHAR (50) UNIQUE NOT NULL); 
EOSQL

psql -v ON_ERROR_STOP=1 -U david -h localhost -w myDB <<-EOSQL
        CREATE TABLE mencions (id SERIAL PRIMARY KEY, nom VARCHAR (50) UNIQUE NOT NULL, grau INT);
EOSQL

#Insert graus
psql -v ON_ERROR_STOP=1 -U david -h localhost -w myDB <<-EOSQL
	INSERT INTO graus (id, nom) VALUES (1, 'gradoA');
	INSERT INTO graus (id, nom) VALUES (2, 'gradoB');
	INSERT INTO graus (id, nom) VALUES (3, 'gradoC');
	INSERT INTO graus (id, nom) VALUES (4, 'gradoD');
EOSQL

psql -v ON_ERROR_STOP=1 -U david -h localhost -w myDB <<-EOSQL
        INSERT INTO mencions (id, nom, grau) VALUES (1, 'mencioA1', 1);
        INSERT INTO mencions (id, nom, grau) VALUES (2, 'mencioB1', 2);
        INSERT INTO mencions (id, nom, grau) VALUES (3, 'mencioC1', 3);
        INSERT INTO mencions (id, nom, grau) VALUES (4, 'mencioD1', 4);
        INSERT INTO mencions (id, nom, grau) VALUES (5, 'mencioB2', 2);
        INSERT INTO mencions (id, nom, grau) VALUES (6, 'mencioC2', 3);
        INSERT INTO mencions (id, nom, grau) VALUES (7, 'mencioD2', 4);
EOSQL
