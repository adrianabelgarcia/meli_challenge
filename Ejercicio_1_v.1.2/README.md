# Ejercicio 1 - Implementación de API REST con EFS y HAProxy (Sin Framework)

Este documento detalla la solución propuesta para cumplir con el Ejercicio 1 del desafio técnico, basado en los requisitos provistos y utilizando el archivo de CloudFormation `CFTemplate.yml`.

---

## 1. Objetivo del ejercicio

Desarrollar una API REST sin framework que permita realizar operaciones CRUD sobre archivos JSON, cumpliendo los siguientes requisitos:

- Usar el template de CloudFormation provisto.
- Utilizar el EFS creado en el template.
- Implementar un sistema de balanceo de carga **sin utilizar AWS ELB**.
- Crear endpoints para:
  - Subir JSON (POST /json)
  - Obtener JSON (GET /json/<id>)
  - Modificar JSON (PUT /json/<id>)
  - Eliminar JSON (DELETE /json/<id>)

---

## 2. Descripción de la arquitectura

- **2 Instancias EC2** privadas definidas por `CFTemplate.yml`.
- Cada instancia monta el sistema de archivos EFS.
- La API está implementada en **Python puro**, sin Flask ni frameworks externos.
- Se usa **HAProxy** en una tercera instancia para balancear el tráfico entre las dos instancias EC2 de forma equitativa (**round-robin**).
- El balanceo considera el estado de salud de las instancias a través de un health check en el puerto `5000`.

---

## 3. Componentes

### ✅ API (Python puro)
Archivo `server.py`. Define la lógica de los endpoints usando `http.server`:

- `POST /json`: Guarda un JSON en `/mnt/efs/<id>.json`.
- `GET /json/<id>`: Lee el archivo.
- `PUT /json/<id>`: Reemplaza el contenido del archivo.
- `DELETE /json/<id>`: Elimina el archivo.

Todos los datos se comparten entre instancias gracias al EFS montado.

### ✅ HAProxy
Archivo `haproxy.cfg`:

- Escucha en el puerto `80`.
- Balancea solicitudes HTTP hacia las instancias EC2 en puerto `5000`.
- Usa `option httpchk` para verificar que el backend esté saludable.

### ✅ Scripts

- `install_api.sh`: Instala dependencias, monta EFS y ejecuta la API.
- `install_haproxy.sh`: Instala HAProxy y carga configuración personalizada.
- `deploy_stack.sh`: Crea y despliega el stack de CloudFormation.

---

## 4. Despliegue

1. Ejecutar el template `CFTemplate.yml` desde CloudFormation.
2. Conectarse a cada instancia EC2 y ejecutar el script de instalación (`install_api.sh`).
3. En la instancia de HAProxy, ejecutar `install_haproxy.sh`.
4. Validar que los endpoints respondan desde la IP del balanceador (`http://<haproxy_ip>/json`).

---

## 5. Resultados Esperados

- Se puede realizar operaciones CRUD sobre archivos JSON.
- Los archivos son persistentes gracias al uso de EFS.
- El balanceador distribuye la carga de forma equitativa.
- Si una instancia falla, HAProxy redirige al nodo sano.

---

## 6. Justificación de decisiones

- **Sin framework**: Cumple con la consigna y permite mayor control.
- **EFS**: Ideal para compartir datos entre instancias.
- **HAProxy**: Solución sencilla y eficiente para balanceo de carga.

---

## 7. Recomendaciones futuras

- Agregar autenticación y validación de datos.
- Crear un sistema de logging centralizado.
- Automatizar el despliegue usando scripts o herramientas como Ansible/Terraform.

