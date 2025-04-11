# 📌 Análisis de Captura de Tráfico - PCAP

## **1️⃣ ¿Qué actividad estaba llevando a cabo el usuario?**
El usuario estaba accediendo a **www.mercadolibre.com.ar** desde su computadora.

### 🔍 **Evidencias en la captura:**
1️⃣ **Petición ARP**: La máquina del usuario pregunta por la dirección MAC del gateway (`10.26.36.1`).
2️⃣ **Consulta DNS**: La máquina busca la IP de `www.mercadolibre.com.ar`.
3️⃣ **Petición HTTP**: Se envía una solicitud `GET /` al servidor de Mercado Libre.
4️⃣ **Redirección HTTP 302**: Mercado Libre responde con una redirección.
5️⃣ **Negociación TLS**: Se inicia una sesión segura con `Client Hello` y `Server Hello`.

📌 **Conclusión:** El usuario estaba accediendo al sitio web de Mercado Libre usando un navegador.

---

## **2️⃣ ¿Qué información relevante se puede extraer?**
La captura de tráfico revela **detalles clave** de la actividad del usuario:

### **🔹 Información sobre la red:**
- **Dirección IP del usuario:** `10.26.36.59`
- **Gateway utilizado:** `10.26.36.1`
- **Servidor DNS utilizado:** `10.200.1.19`
- **IP del servidor de Mercado Libre:** `13.33.134.245` (CloudFront CDN)

### **🔹 Información sobre la conexión a Mercado Libre:**
- **El sitio usa CloudFront CDN** (`d3n1b0ot4n5cbd.cloudfront.net`).
- **El usuario se conectó por HTTPS (TLS 1.2)** después de una redirección HTTP 302.
- **No se ven credenciales ni datos sensibles en la captura** (porque la sesión HTTPS se estableció antes de cualquier transmisión de datos privados).

📌 **Conclusión:** Se puede determinar que el usuario navegó en Mercado Libre, pero no hay evidencia de que haya ingresado credenciales o realizado transacciones.

---

## **3️⃣ ¿Qué pasos a nivel conectividad se pueden identificar?**

1️⃣ **Resolución de dirección MAC (ARP):**  
   - La máquina del usuario (`10.26.36.59`) pregunta quién es `10.26.36.1` (su gateway).
   - El router responde con su dirección MAC (`00:04:96:99:29:3d`).

2️⃣ **Resolución de DNS:**  
   - El usuario consulta el servidor DNS (`10.200.1.19`) por la IP de `www.mercadolibre.com.ar`.
   - La respuesta devuelve un **CNAME** (`d3n1b0ot4n5cbd.cloudfront.net`) y la IP `13.33.134.245`.

3️⃣ **Conexión HTTP inicial:**  
   - La computadora del usuario envía un `GET /` a `13.33.134.245`.
   - El servidor responde con `HTTP 302 Found`, indicando una redirección.

4️⃣ **Establecimiento de sesión segura (TLS):**  
   - El cliente inicia `Client Hello` con `SNI=www.mercadolibre.com.ar`.
   - El servidor responde con `Server Hello`, confirmando el cifrado TLS.

📌 **Conclusión:** Se identifican **cuatro pasos clave**: ARP → DNS → HTTP → TLS.

---

## **📌 Resumen Final**
| **Pregunta**                             | **Respuesta**                                                       |
|------------------------------------------|---------------------------------------------------------------------|
| **¿Qué hacía el usuario?**               | Navegaba en **www.mercadolibre.com.ar**.                            |
| **¿Qué información se obtuvo?**          | La IP del usuario, gateway, DNS y que Mercado Libre usa CloudFront. |
| **¿Qué pasos de conectividad se vieron?**| ARP → DNS → HTTP → TLS.                                             |

🚀 **Este análisis permite entender la actividad del usuario y cómo se conectó a Mercado Libre.**