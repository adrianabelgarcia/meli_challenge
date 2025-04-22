#!/bin/bash
apt update -y && apt install -y nfs-common python3 python3-pip

# Montar EFS
mkdir -p /mnt/efs
mount -t nfs4 -o nfsvers=4.1 fs-XXXXXXX.efs.us-east-1.amazonaws.com:/ /mnt/efs

# Descargar el código
git clone https://github.com/tuusuario/api-rest-efs.git /opt/api
cd /opt/api/api

# Ejecutar la API
nohup python3 server.py &
