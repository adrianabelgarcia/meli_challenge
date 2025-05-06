
# Instructivo para Implementar y Gestionar el Stack en AWS

Este instructivo describe cómo implementar la infraestructura en AWS utilizando CloudFormation, probar la API Backend y destruir los recursos cuando ya no se necesiten.

## Requisitos previos

1. **AWS CLI** configurada: Asegúrate de tener la AWS CLI instalada y configurada con las credenciales adecuadas. Si aún no la tienes, sigue estos pasos:
   - Instalar AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
   - Configurar AWS CLI: `aws configure`

2. **Permisos IAM adecuados**: El usuario que ejecute los comandos debe tener permisos para crear y administrar recursos en AWS, como EC2, VPC, IAM, CloudFormation, etc.

---

## 1. **Desplegar el Stack**

### Paso 1: Subir el Template de CloudFormation

El archivo `infraestructura.yaml` es el template que define la infraestructura de AWS. Antes de ejecutar el despliegue, debes asegurarte de que este archivo esté disponible en el directorio `cloudformation`.

### Paso 2: Ejecutar el script de despliegue

Para crear la infraestructura en AWS, ejecuta el script `deploy.sh` que automatiza la creación del stack de CloudFormation.

#### Comando:
```bash
./script/deploy.sh
```

Este script hará lo siguiente:
- Desplegar el **CloudFormation Stack** con el template `infraestructura.yaml`.
- Configurar la infraestructura de AWS con todos los recursos descritos: VPC, subredes públicas y privadas, ALB, CloudFront, Auto Scaling Group, etc.
- Imprimir la URL del **CloudFront** y el **DNS del ALB** una vez que el stack esté completamente desplegado.

### Salida esperada:
El script imprimirá las URLs públicas para acceder a tu API a través de **CloudFront** o el **Application Load Balancer (ALB)**.

---

## 2. **Probar la API**

Una vez que el stack esté desplegado y tengas la URL de **CloudFront** o el **ALB**, puedes comenzar a realizar pruebas sobre la API.

### Paso 1: Probar los Endpoints CRUD

Ejecuta el script `crud.sh` para hacer pruebas CRUD en la API que has desplegado.

#### Comando:
```bash
./script/crud.sh <URL>
```

Reemplaza `<URL>` con la URL que obtuviste del despliegue (CloudFront o ALB). Este script realizará las siguientes operaciones:
- **Crear** un nuevo recurso (POST)
- **Leer** el estado de la API y recursos creados (GET)
- **Actualizar** un recurso (PUT)
- **Eliminar** un recurso (DELETE)
- Probar casos de error (por ejemplo, intentar crear un recurso sin `id` o intentar acceder a un recurso que no existe).

### Salida esperada:
El script imprimirá los resultados de las operaciones CRUD realizadas, y te permitirá verificar que la API esté respondiendo correctamente a las solicitudes.

---

## 3. **Destruir el Stack**

Cuando hayas terminado de probar el stack y ya no necesites los recursos en AWS, puedes destruir la infraestructura para evitar costos adicionales.

### Paso 1: Ejecutar el script de destrucción

Para destruir la infraestructura, ejecuta el script `destroy.sh` que eliminará el stack de CloudFormation y todos los recursos creados.

#### Comando:
```bash
./script/destroy.sh
```

Este script hará lo siguiente:
- Destruirá el **CloudFormation Stack**, eliminando todos los recursos asociados como EC2, VPC, subredes, ALB, CloudFront, EFS, etc.
- Asegúrate de revisar la salida para confirmar que todos los recursos han sido eliminados.

### Salida esperada:
El script imprimirá un mensaje confirmando que la pila ha sido destruida correctamente.

---

## Estructura de Archivos

La estructura de archivos del proyecto es la siguiente:

```
.
├── cloudformation
│   └── infraestructura.yaml      # Template de CloudFormation para desplegar la infraestructura
├── debug.txt                     # Archivo de registro para debug (si es necesario)
├── infrastructure_readme.md       # Este archivo, que describe la infraestructura y su uso
└── script
    ├── crud.sh                   # Script para probar los endpoints CRUD de la API
    ├── deploy.sh                 # Script para desplegar el stack de CloudFormation
    └── destroy.sh                # Script para destruir el stack de CloudFormation
```

---

## Notas Adicionales

- Asegúrate de que tienes los permisos adecuados para ejecutar estas operaciones en tu cuenta de AWS.
- Si tienes alguna duda o necesitas ayuda con la configuración de algún recurso en AWS, no dudes en contactarme.
- Recuerda que este stack utiliza **Auto Scaling Groups**, por lo que el número de instancias backend puede cambiar según la carga.
- **CloudFront** se utiliza para distribuir el tráfico de la API, mejorando el rendimiento y la latencia de las solicitudes.

---

Este instructivo cubre todo lo que necesitas para **desplegar**, **probar** y **destruir** el stack. Si necesitas más detalles o ajustes adicionales, ¡estaré encantado de ayudarte!
