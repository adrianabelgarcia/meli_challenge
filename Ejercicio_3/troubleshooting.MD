# 📌 Localización del Servidor con IP 10.32.0.84 en la Red Cisco

## **1️⃣ Identificación de la Conexión en el Router**
Para determinar en qué punto de la red está conectado el servidor, primero verificamos su entrada en la tabla ARP del router principal:
```
show ip arp 10.32.0.84
```
📌 **Ejemplo de salida:**  
```
Protocol  Address        Age (min)  Hardware Addr   Type   Interface
Internet  10.32.0.84     2         00:1A:2B:3C:4D:5E  ARPA   GigabitEthernet0/1
```
💡 **El servidor está conectado a `GigabitEthernet0/1` en el router.**  

---

## **2️⃣ Seguimiento de la MAC en los Switches de Distribución**  
Una vez obtenida la dirección MAC, localizamos el puerto al que está asociado dentro del switch de distribución:
```
show mac address-table address 00:1A:2B:3C:4D:5E
```
📌 **Ejemplo de salida:**  
```
Mac Address Table
-------------------------------------------
VLAN    MAC Address        Type      Ports
10      00:1A:2B:3C:4D:5E  Dynamic   Gig1/0/5
```
💡 **El servidor está conectado al puerto `Gig1/0/5` en un switch de distribución.**  

---

## **3️⃣ Identificación del Switch TOR (Top-of-Rack)**  
Para encontrar el switch TOR al que está conectado el servidor, utilizamos el siguiente comando en el switch de distribución:
```
show cdp neighbors
```
📌 **Ejemplo de salida:**  
```
Device ID        Local Intrfce    Holdtme    Capability  Platform  Port ID
Switch-TOR-1     Gig 1/0/5        178        S I        WS-C3850   TenGig 1/1/3
```
💡 **El servidor está en `Switch-TOR-1`, puerto `TenGig 1/1/3`.**  

---

## **4️⃣ Confirmación de la Conexión en el Switch TOR**  
Para verificar la conexión final, consultamos la tabla de direcciones MAC en el switch TOR:
```
show mac address-table address 00:1A:2B:3C:4D:5E
```
📌 **Salida esperada:**  
```
Mac Address Table
-------------------------------------------
VLAN    MAC Address        Type      Ports
10      00:1A:2B:3C:4D:5E  Dynamic   TenGig 1/1/3
```
💡 **¡El servidor está conectado en `Switch-TOR-1`, puerto `TenGig 1/1/3`!**  

---

## **5️⃣ Resumen de Pasos**
✅ **Consultar la tabla ARP** en el router con `show ip arp 10.32.0.84` para obtener la MAC Address.  
✅ **Localizar la MAC en los switches de distribución** con `show mac address-table address <MAC>`.  
✅ **Determinar el switch TOR** usando `show cdp neighbors`.  
✅ **Confirmar la conexión final** en el switch TOR con `show mac address-table address <MAC>`.  

🚀 **Este proceso permite ubicar cualquier servidor dentro de la red de manera rápida y precisa.**

