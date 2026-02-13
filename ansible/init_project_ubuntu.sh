#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED} Repo updates ${NC}"
sudo apt update

echo -e "${RED} Install Ansible ${NC}"
sudo apt install -y ansible sshpass

echo -e "${RED} Install required galaxy roles ${NC}"
ansible-galaxy install -r requirements.yml

echo -e "${RED}Do not forget to decrypt the repo credentials file - Check README.md file ${NC}"



