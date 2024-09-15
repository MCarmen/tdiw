#!/bin/bash
set -e

#Create Dockerfile
cat <<EOF > Dockerfile
FROM php:7.2-apache

RUN apt-get update

# Install Postgre PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql
EOF

#Docker build
docker build -t apache-php-pdo_pgsql .

#Docker with apache-php-pdo_pgsql
docker run -d --name p4-php --network="host" -v "$PWD":/var/www/html apache-php-pdo_pgsql:latest

#Create PostgreSQL DB Docker
docker run --name p4-db -p 5432:5432 -e POSTGRES_USER=david -e POSTGRES_DB=myDB -e POSTGRES_PASSWORD=password -d postgres

#Wait 5 seconds for DB to be ready
sleep 5

export PGPASSWORD=password

#Create graus table
psql -v ON_ERROR_STOP=1 -U david -h localhost -w myDB <<-EOSQL
	CREATE TABLE graus (id varchar(1), nom VARCHAR (50) UNIQUE NOT NULL); 
EOSQL

#Create mencions table
psql -v ON_ERROR_STOP=1 -U david -h localhost -w myDB <<-EOSQL
        CREATE TABLE mencions (id varchar(1), nom VARCHAR (50) UNIQUE NOT NULL, grau INT);
EOSQL

#Insert graus
psql -v ON_ERROR_STOP=1 -U david -h localhost -w myDB <<-EOSQL
	INSERT INTO graus (id, nom) VALUES ('I', 'Enginyeria Informàtica');
	INSERT INTO graus (id, nom) VALUES ('T', 'Enginyeria de Sistemes de Telecomunicació');
	INSERT INTO graus (id, nom) VALUES ('E', 'Enginyeria Electrònica de Telecomunicació');
	INSERT INTO graus (id, nom) VALUES ('Q', 'Enginyeria Química');
EOSQL

#Insert mencions
psql -v ON_ERROR_STOP=1 -U david -h localhost -w myDB <<-EOSQL
        INSERT INTO mencions (id, nom, grau) VALUES ('S', 'Enginyeria del software', 1);
        INSERT INTO mencions (id, nom, grau) VALUES ('A', 'Enginyeria de computadors', 1);
        INSERT INTO mencions (id, nom, grau) VALUES ('C', 'Computació', 1);
        INSERT INTO mencions (id, nom, grau) VALUES ('I', 'Tecnologies de la informació', 1);
EOSQL
