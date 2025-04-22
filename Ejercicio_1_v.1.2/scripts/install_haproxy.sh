#!/bin/bash
apt update -y && apt install -y haproxy #instalo dependencias

# Copiar config
cp /opt/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg    #copio config
systemctl restart haproxy    #reinicio servicio
