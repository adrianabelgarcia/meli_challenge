#!/bin/bash
apt update -y && apt install -y haproxy

# Copiar config
cp /opt/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg
systemctl restart haproxy
