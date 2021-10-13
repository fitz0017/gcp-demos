#!/bin/bash

# This script will pull down and install the lastest stable version of Postgres.  
# Input desired user as first argument for -u flag
# Compatible with Debian distros. 
# Script will also create a local user and password.

usage(){
  echo "${0} -u USERNAME -n DB_NAME [-s SEED]"
  echo "This script will download and install the latest version of Postgres, and create initial non-root user and database with provided names."
  echo "  -u USERNAME required."
  echo "  -n DB_NAME optional, without this option one will be created for you."
  echo "  -s SEED this seed will be used in password creation.  Use at least 4 alphanumeric characters."
}
 
if [[ ${UID} -eq 0 ]]
then
  echo "No need to run this script as root, please try again" >&2
  usage
  exit 1
fi

if [[ ! ${1} ]]
then
  echo "No user provided, please try again with USERNAME" >&2
  usage
  exit 1
fi

# Download Postgres
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' &>/dev/null
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - &>/dev/null
sudo apt-get update &>/dev/null
sudo apt-get -y install postgresql &>/dev/null

# Create User
USER=${1}
sudo -u postgres createuser ${USER}

# Create DB 
DB_NAME=${2}
sudo -u postgres createdb ${DB_NAME}

# Create Password
# PASSWORD=$(date +%F%N | sha256sum | head -c12)
# CREATE USER $USER --PASSWORD ${PASSWORD}
if [[ ${?} -ne 0 ]]
then
  echo "Postgres user creation failed." >&2
  exit 1
fi

#Print out local user and password to local file. 
