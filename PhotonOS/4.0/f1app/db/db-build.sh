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

# Create ORM application folder (with database connection):
mkdir -p /opt/f1orm
chown photon:users /opt/f1orm
echo "DATABASE_URL=\"mysql://f1user:${PASS}@localhost:3306/f1db?connection_limit=5\"" > /opt/f1orm/.env
chown photon:users /opt/f1orm/.env

# Application setup
cp -R /root/scripts/PhotonOS/4.0/f1app/db/f1orm/* /opt/f1orm
chown -R photon:users /opt/f1orm/
su photon -c 'cd /opt/f1orm; npm install prisma --save-dev; npm install'