
# 🚀 GitHub Actions Pipeline para Actualizar Backend en ASG

Este pipeline permite a los desarrolladores actualizar de manera automática y segura el backend (server.py) que corre en las instancias del **Auto Scaling Group (ASG)** en AWS.  
Cada vez que un cambio es realizado en `server.py` en la rama donde esta el trigger del repositorio, las instancias serán actualizadas automáticamente sin necesidad de intervenir manualmente.

---

## 📦 ¿Qué hace esta pipeline?

- Detecta cambios en el archivo:

```
Desafio_v2/api_v2/api/server.py
```

- Por cada push a la rama correspondiente, hace lo siguiente:

1. Obtiene todas las instancias EC2 asociadas al Auto Scaling Group (ASG).
2. Ejecuta un comando remoto en cada instancia usando **AWS Systems Manager (SSM)**:
   - Hace backup de la versión actual de `/home/ec2-user/server.py`.
   - Descarga la nueva versión del archivo directamente desde GitHub.
   - Mata el proceso anterior de `server.py` si está corriendo.
   - Lanza la nueva versión de `server.py` en segundo plano usando `nohup`.

---

## 📌 Beneficios

- **Automatización total** del despliegue de cambios en el backend.
- **Cero tiempo de inactividad planeado** gracias a la actualización in-place de las instancias.
- **Rollback simple** en caso de errores, ya que se mantiene una copia `server.py.bak`.
- **Seguridad**: uso de AWS SSM sin necesidad de exponer puertos SSH.

---

## 🚦 Flujo de trabajo (workflow)

```plaintext
Desarrollador -> Push a main -> GitHub Actions -> SSM -> Instancias EC2 (ASG) -> Actualización del backend
```

---

## 📂 Ubicación del archivo workflow

El archivo de configuración de GitHub Actions se encuentra en:

```
.github/workflows/update-backend.yml
```

---

## 🔧 Configuración necesaria

### Secrets en GitHub

Debes configurar las credenciales de AWS en tu repositorio:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

**Ruta:**  
Repository → Settings → Secrets → Actions → New repository secret

### Requisitos en las instancias EC2

- Deben tener el **SSM Agent instalado y corriendo** (en tu caso ya está instalado desde el UserData).
- Deben tener un **IAM Role con políticas de acceso a SSM**:
  - `AmazonSSMManagedInstanceCore`

---

## 🚀 ¿Cómo usar?

1. Realizar un cambio en el archivo `Desafio_v2/api_v2/api/server.py` y hacer push a `main`.
2. GitHub Actions ejecutará automáticamente la pipeline.
3. Las instancias en el ASG actualizarán su backend sin intervención manual.
4. Verifica los logs en GitHub Actions para asegurarte que todo salió bien.

---

## 📌 Notas

- **Rollback manual**: Si el nuevo backend falla, puedes volver manualmente a `server.py.bak` en las instancias.
- **Monitoreo**: Es recomendable tener un endpoint de salud (`/health` o `/status`) para verificar que el backend se levantó correctamente.
- **Mejoras futuras**:
  - Validación automática post despliegue.
  - Rollback automático si el nuevo código no responde correctamente.

---

Con esta solución, cualquier desarrollador puede actualizar la API de manera simple, segura y sin tiempos de inactividad significativos.

