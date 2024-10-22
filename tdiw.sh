#!/bin/bash
set -e

# Removing old tdiw dockers
TDIW_DOCKERS=$(docker ps -a -q -f name=tdiw)
if [ ! -z "${TDIW_DOCKERS}" ]
then
    echo "Removing old tdiw dockers"
    docker rm -f $TDIW_DOCKERS
fi

#Create Dockerfile
cat <<EOF > Dockerfile
FROM php:8.3-apache

RUN apt-get update

# Install Postgre PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql
EOF

#Docker build
docker build -t apache-php-pdo_pgsql .

#Docker with apache-php-pdo_pgsql
docker run -d --name tdiw-php --network="host" -v "$PWD":/var/www/html apache-php-pdo_pgsql:latest

#Create PostgreSQL DB Docker
docker run --name tdiw-db -p 5432:5432 -e POSTGRES_USER=david -e POSTGRES_DB=myDB -e POSTGRES_PASSWORD=password -d postgres

#Wait 5 seconds for DB to be ready
sleep 5

export PGPASSWORD=password

#Create graus table
docker run -i --rm --network="host" -e PGPASSWORD=password postgres psql -v ON_ERROR_STOP=1 -U david -h localhost -d myDB -w <<-EOSQL
	CREATE TABLE graus (id SERIAL PRIMARY KEY, nom VARCHAR (50) UNIQUE NOT NULL); 
EOSQL

#Create mencions table
docker run -i --rm --network="host" -e PGPASSWORD=password postgres psql -v ON_ERROR_STOP=1 -U david -h localhost -d myDB -w <<-EOSQL
        CREATE TABLE mencions (id SERIAL PRIMARY KEY, nom VARCHAR (50) UNIQUE NOT NULL, grau INT REFERENCES graus(id));
EOSQL

#Insert graus
docker run -i --rm --network="host" -e PGPASSWORD=password postgres psql -v ON_ERROR_STOP=1 -U david -h localhost -d myDB -w <<-EOSQL
	INSERT INTO graus (nom) VALUES ('Enginyeria Informàtica');
	INSERT INTO graus (nom) VALUES ('Enginyeria de Sistemes de Telecomunicació');
	INSERT INTO graus (nom) VALUES ('Enginyeria Electrònica de Telecomunicació');
	INSERT INTO graus (nom) VALUES ('Enginyeria Química');
EOSQL

#Insert mencions
docker run -i --rm --network="host" -e PGPASSWORD=password postgres psql -v ON_ERROR_STOP=1 -U david -h localhost -d myDB -w <<-EOSQL
        INSERT INTO mencions (nom, grau) VALUES ('Enginyeria del software', 1);
        INSERT INTO mencions (nom, grau) VALUES ('Enginyeria de computadors', 1);
        INSERT INTO mencions (nom, grau) VALUES ('Computació', 1);
        INSERT INTO mencions (nom, grau) VALUES ('Tecnologies de la informació', 1);
        INSERT INTO mencions (nom, grau) VALUES ('Antenes1', 2);
        INSERT INTO mencions (nom, grau) VALUES ('Antenes2', 2);
        INSERT INTO mencions (nom, grau) VALUES ('RadioFreq',2);

EOSQL
#Remove Dockerfile
rm -f Dockerfile