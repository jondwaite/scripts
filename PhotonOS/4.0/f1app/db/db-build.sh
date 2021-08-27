#!/bin/bash

# DB Build Script (Photon OS 4.0GA)

tdnf install -y mariadb
tdnf install -y mariadb-server
tdnf install -y nodejs

# Start and enable the database
systemctl enable mariadb
systemctl start mariadb

# Grab the f1 database and add to mariadb
wget http://ergast.com/downloads/f1db.sql.gz
gunzip f1db.sql.gz
mysql -u root -e "CREATE DATABASE f1db"
mysql -u root f1db < f1db.sql
rm -f f1db.sql

# Generate a random password for the database
PASS=`openssl rand -base64 18`

# Create the database user and set permissions:
mysql -u root -e "CREATE USER 'f1user'@'localhost' IDENTIFIED BY '${PASS}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON f1db.* TO 'f1user'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Generate a dotenv file:
echo "DB_HOST=localhost" > .env
echo "DB_USER=f1user" >> .env
echo "DB_PASS=${PASS}" >> .env
echo "DB_DATABASE=f1db" >> .env
