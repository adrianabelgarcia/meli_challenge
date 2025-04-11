# 🔗 Conectividad entre VPCs en AWS

Este documento presenta dos estrategias para conectar tres VPCs en AWS, evaluando **costos**, **seguridad** y **escalabilidad**, y proporcionando una recomendación basada en el caso de uso.

---

## **1️⃣ Opción 1: VPC Peering (Eficiente y Seguro)**

### ✅ **Ventajas**
- **Costo reducido** → Solo se paga por el tráfico entre VPCs.
- **Tráfico seguro y privado** → No pasa por Internet.
- **Configuración sencilla** → Ideal para redes pequeñas o medianas.

### 🔴 **Desventajas**
- **Limitaciones en escalabilidad** → Requiere múltiples conexiones si aumentan las VPCs.
- **Sin comunicación transitiva** → Cada VPC debe establecer un peering directo con las demás.

🔧 **Cuándo usarlo:** Cuando el número de VPCs es reducido y se prioriza seguridad y costos bajos.

---

## **2️⃣ Opción 2: AWS Transit Gateway (Flexible y Escalable)**

### ✅ **Ventajas**
- **Escalabilidad** → Permite conectar cientos de VPCs a una única estructura.
- **Administración centralizada** → No requiere múltiples conexiones individuales.
- **Alta seguridad** → Todo el tráfico se mantiene dentro de la red de AWS.

### 🔴 **Desventajas**
- **Costo mayor** → Se cobra por el tráfico y la conexión por hora.
- **Mayor configuración** → Requiere definir tablas de ruteo y asociaciones.

🔧 **Cuándo usarlo:** Cuando se espera crecimiento en la cantidad de VPCs y se necesita administración simplificada.

---

## **3️⃣ Comparación entre Opciones**

| Opción              | Costos  | Seguridad | Escalabilidad | Complejidad |
|---------------------|---------|-----------|---------------|-------------|
| **VPC Peering**     | Bajo    | Alta      | Baja          | Media       |
| **Transit Gateway** | Medio   | Alta      | Alta          | Alta        |

---

## **4️⃣ Conclusión y Recomendación**
✅ **Si el objetivo es minimizar costos y mantener alta seguridad** → **VPC Peering** es la mejor opción.  
✅ **Si se requiere escalabilidad y facilidad de administración** → **AWS Transit Gateway** es más adecuado.  

📌 **Elegir la solución dependerá del crecimiento esperado de la red y las necesidades del negocio.**

