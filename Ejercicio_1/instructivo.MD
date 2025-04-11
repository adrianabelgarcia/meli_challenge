# 📌 Infraestructura para la API REST en AWS

Este documento detalla la arquitectura implementada para desplegar una API REST en AWS utilizando **CloudFormation**, cumpliendo con los requerimientos establecidos en el **Ejercicio 1**.

---

## **1️⃣ Infraestructura en AWS**

### **🔹 Configuración de Red (VPC y Subnet)**
Se establece una **VPC privada** con una **subred pública** para garantizar la conectividad de los servidores.

### **🔹 Seguridad y Control de Acceso**
Se configuran **grupos de seguridad** con las siguientes reglas:
- **SSH (22)** → Restringido solo para tareas de administración.
- **HTTP (80)** → Acceso público para la API.
- **EFS (2049)** → Permite la comunicación entre los servidores y el almacenamiento compartido.

### **🔹 Almacenamiento Persistente con EFS**
Se implementa **Amazon Elastic File System (EFS)** para almacenamiento compartido entre los servidores.
- Almacena los archivos JSON procesados por la API.
- Se monta en `/mnt/efs` en cada servidor EC2, asegurando disponibilidad y persistencia de datos.

---

## **2️⃣ Balanceo de Carga con HAProxy**

Para distribuir el tráfico de manera equitativa entre los servidores de aplicación, se configura un **balanceador de carga basado en HAProxy**.
- Implementa el algoritmo **round-robin** para optimizar el uso de recursos.
- Se habilitan **chequeos de salud** para detectar y excluir servidores inactivos.

🔍 **Nota:** No se utiliza **AWS ELB**, cumpliendo con la restricción especificada en el ejercicio.

---

## **3️⃣ Implementación de los Servidores de Aplicación**

Se despliegan **dos instancias EC2** que ejecutan la API REST.
- Se instalan dependencias como **Python y Flask**.
- Se clona el código desde **GitHub** y se ejecuta automáticamente al iniciar la instancia.
- Se configura el almacenamiento en **EFS** para compartir información entre servidores.

📌 **Cada instancia es accesible a través de `http://<IP>:5000`, con el tráfico gestionado por HAProxy.**

---

## **4️⃣ API REST - Funcionalidades y Endpoints**

✅ `POST /json` → Sube un archivo JSON utilizando un identificador único.
✅ `GET /json/<id>` → Recupera un JSON almacenado.
✅ `PUT /json/<id>` → Modifica un archivo JSON existente.
✅ `DELETE /json/<id>` → Elimina un archivo JSON.

📌 **Todos los archivos se almacenan en `/mnt/efs` para garantizar disponibilidad y persistencia.**

---

## **5️⃣ Automatización del Despliegue**

Para facilitar la implementación de la infraestructura, se proporciona un script `deploy.sh` que ejecuta los despliegues en el siguiente orden:
```bash
bash deploy.sh
```
El script realiza las siguientes acciones:
1️⃣ **Configura la VPC y Subnet**
2️⃣ **Establece los Grupos de Seguridad**
3️⃣ **Despliega el sistema de almacenamiento en EFS**
4️⃣ **Configura HAProxy como balanceador de carga**
5️⃣ **Lanza las instancias EC2 con la API**

🚀 **Tras la ejecución del script, la API REST queda lista para su uso.**


