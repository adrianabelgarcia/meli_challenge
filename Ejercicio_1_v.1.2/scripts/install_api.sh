#!/bin/bash
apt update -y && apt install -y nfs-common python3 python3-pip  #ejemplo instalar dependencias

# Montar EFS
mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1 fs-qwert1234.efs.us-east-1.amazonaws.com:/ /mnt/efs    #ejemplo montar efs

# Descargar el código
git clone git@github.com:adrianabelgarcia/meli_challenge.git /opt/api      #ejemplo clonar repositorio                  

# Ejecutar la API
nohup python3 server.py &    #ejemplo ejecutar api
