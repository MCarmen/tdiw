# TDIW
Tecnologies de desenvolupament per a Internet i Web

SESSIÓ DE PROBLEMES 4 – Programació a la banda del servidor (PHP)

## Create the environment
In this repository, you can find the **p4.sh** script, which will create two containers, one with Apache + PHP service and another with PostgreSQL DB, and the data needed to perform the P4 exercise. 
To create the environment, just run the **p4.sh** script
```shell
./p4.sh
```

## Destroy the environment
To destroy the P4 containers, run the following commands:
```shell
docker rm -f p4-php p4-db
```
## Access to the website
[http://localhost](http://localhost)
