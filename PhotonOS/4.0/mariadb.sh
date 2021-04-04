#!/bin/sh

# https://raw.githubusercontent.com/jondwaite/scripts/main/PhotonOS/4.0/mariadb.sh

tdnf install -y mariadb
tdnf install -y mariadb-server

# Start and enable the database
systemctl enable mariadb
systemctl start mariadb

# Grab the f1 database and add to mariadb
wget http://ergast.com/downloads/f1db.sql.gz
gunzip f1db.sql.gz
mysql -u root -e "CREATE DATABASE f1db"
mysql -u root f1db < f1db.sql

