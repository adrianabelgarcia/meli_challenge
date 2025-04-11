# 🔍 Troubleshooting BGP - Cisco

Este documento detalla el análisis de las sesiones BGP en la red, identificando diferencias entre conexiones **iBGP** y **eBGP**, además de estrategias para diagnosticar y solucionar problemas de conectividad con los proveedores de nube (AWS, GCP, Azure).

---

## **📌 1. Diferencias entre las sesiones BGP**

### **🔹 Sesión #1 (A ↔ B, dentro de ASN 65000, Backbone conectado a Proveedores Cloud)**  
✅ **Tipo:** **iBGP** (Internal BGP)  
✅ **Características:**  
- Ambos routers pertenecen al mismo **ASN (65000)** del backbone.  
- Conectan el backbone a los proveedores de nube (**AWS, GCP, Azure**) a través de la sesión **ASN 65003**.  
- No modifican el **Next-Hop** de las rutas anunciadas.  
- Requieren una configuración **full-mesh** o el uso de **Route Reflectors** para la propagación de rutas.  

### **🔹 Sesión #2 (A ↔ C, conexión entre el Backbone y el Datacenter)**  
✅ **Tipo:** **eBGP** (External BGP)  
✅ **Características:**  
- Conexión entre **AS distintos** (**65000 ↔ 65001**).  
- **El Next-Hop cambia** para garantizar la correcta redistribución de rutas.  
- No requiere full-mesh, ya que cada router solo establece sesión con su vecino BGP.  
- Puede aplicar **políticas de filtrado** más estrictas, como **MED**, **Local Preference** y filtrado de prefijos.  

### **🔹 Sesión #3 (C ↔ D, dentro del Datacenter, ASN 65001)**  
✅ **Tipo:** **iBGP** (Internal BGP dentro del Datacenter)  
✅ **Características:**  
- Ambos routers pertenecen a **ASN 65001** dentro del datacenter.  
- No se cambia el **Next-Hop**, lo que requiere configuraciones adicionales para redistribuir rutas.  
- Puede usar **Route Reflectors** si hay múltiples conexiones dentro del datacenter.  

📌 **Diferencia clave:** **Las sesiones dentro de un mismo ASN (iBGP) requieren propagación especial de rutas, mientras que las sesiones entre AS diferentes (eBGP) implican cambios de Next-Hop y aplicación de políticas.**

---

## **📌 2. Diagnóstico de Problemas entre el Backbone y el Cloud Provider**

### **🔍 Posibles causas:**
1️⃣ **Falta de anuncios de rutas** → El Cloud Provider no está recibiendo las rutas del backbone.  
2️⃣ **Filtros de tráfico en políticas BGP** → Puede estar bloqueando prefijos o cambiando atributos críticos.  
3️⃣ **Sesión BGP inactiva** → Problemas de configuración o conectividad entre los routers.  
4️⃣ **Next-Hop incorrecto** → La red puede estar enviando tráfico a una IP no accesible.

---

## **📌 3. Comandos de Troubleshooting en Cisco**

### **1️⃣ Verificar el estado de la sesión BGP**
```bash
show ip bgp summary
```
📌 **Salida esperada:**  
```
Neighbor        V    AS  MsgRcvd  MsgSent  Up/Down  State/PfxRcd
192.168.1.1     4  65000   1234     5678   10:05:32  100
```
🔍 **Si el estado no es `Established`, la sesión BGP está caída.**  

### **2️⃣ Verificar las rutas BGP recibidas del Cloud Provider**
```bash
show ip bgp neighbors 192.168.1.1 received-routes
```

### **3️⃣ Verificar las rutas que se están anunciando al Cloud Provider**
```bash
show ip bgp neighbors 192.168.1.1 advertised-routes
```

### **4️⃣ Comprobar si las rutas están siendo filtradas**
```bash
show ip bgp neighbor 192.168.1.1 route-map
```

### **5️⃣ Validar la conectividad con el Cloud Provider**
```bash
ping 192.168.1.1 source Loopback0
```

---

## **📌 4. Soluciones Técnicas**

✅ **1️⃣ Si la sesión BGP no se establece:**
```bash
router bgp 65000
 neighbor 192.168.1.1 remote-as 65003
```

✅ **2️⃣ Si no hay anuncios de rutas:**
```bash
router bgp 65000
 network 10.0.0.0 mask 255.255.255.0
```

✅ **3️⃣ Si hay filtros bloqueando anuncios:**
```bash
route-map ALLOW-ALL permit 10
 match ip address prefix-list ALL
```

✅ **4️⃣ Si hay problemas con el Next-Hop:**
```bash
router bgp 65000
 neighbor 192.168.1.1 next-hop-self
```

---

## **📌 5. Resumen Final**

| Problema                     | Posible Causa                        | Comando de Diagnóstico                  | Solución Técnica                     |
|------------------------------|-------------------------------------|-----------------------------------------|---------------------------------------|
| Sesión BGP caída             | Conectividad, autenticación MD5     | `show ip bgp summary`                   | Revisar conectividad, autenticación   |
| No hay anuncios de rutas     | Cloud Provider no está enviando     | `show ip bgp neighbors received-routes` | Revisar configuración BGP             |
| Rutas no se propagan         | Route maps bloquean anuncios        | `show ip bgp neighbor route-map`        | Modificar o eliminar filtros          |
| Next-Hop no alcanzable       | BGP no cambia el Next-Hop           | `show ip bgp`                           | Configurar `next-hop-self` en iBGP    |

🚀 **Este procedimiento proporciona un enfoque estructurado para diagnosticar y resolver problemas de BGP en una red Cisco que conecta un Backbone con proveedores de nube y un Datacenter.**

