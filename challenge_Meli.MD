# 📌 Challenge Meli 
Estructura del repositorio:
.
├── Ejercicio_1
│   ├── cloudformation
│   │   ├── ec2.yml
│   │   ├── efs.yml
│   │   ├── haproxy.yml
│   │   ├── main.yml
│   │   ├── security_groups.yml
│   │   └── vpc.yml
│   ├── instructivo.MD
│   └── scripts
│       └── deploy.sh
├── Ejercicio_2
│   ├── Opcion_1
│   │   ├── Opcion_1.MD
│   │   └── vpc_peering.yml
│   ├── Opcion_2
│   │   ├── Opcion_2.MD
│   │   └── TransitGateway.yml
│   └── resumen.MD
├── Ejercicio_3
│   └── troubleshooting.MD
├── Ejercicio_4
│   └── ejercicio_4.MD
├── Ejercicio_5
│   └── Ejercicio_5.MD
└── Ejercicios
    ├── captura.pcap
    ├── cf_template.yml
    └── challenge_mercado_libre_v1.0.pdf

Este desafío me permitió poner en práctica habilidades clave en infraestructura cloud, redes y automatización. Desde el principio, mi enfoque fue claro: diseñar una solución eficiente, escalable y bien documentada. Trabajé con **AWS CloudFormation** para automatizar el despliegue, exploré diferentes estrategias de conectividad entre redes y me sumergí en troubleshooting avanzado para resolver problemas de infraestructura.

No solo se trató de escribir código, sino de comprender **qué soluciones eran las mejores para cada escenario**. A lo largo de este proceso, tuve que tomar decisiones sobre balanceo de carga, persistencia de datos, enrutamiento BGP y seguridad en redes. Este documento es el reflejo de ese camino y de cómo fui abordando cada problema con lógica, paciencia y un enfoque sistemático.

---

# 📌 Introducción

El proyecto se compone de varios ejercicios diseñados para desafiar mi capacidad de diseñar, implementar y solucionar problemas en infraestructuras en la nube.

- **Ejercicio 1:** Implementación de una API REST en AWS con CloudFormation, utilizando HAProxy como balanceador y almacenamiento en EFS.
- **Ejercicio 2:** Análisis de dos estrategias para conectar múltiples VPCs: **VPC Peering** (seguro y económico) vs. **Transit Gateway** (más escalable).
- **Ejercicio 3:** Diagnóstico de problemas de conectividad en una red corporativa utilizando herramientas y comandos de troubleshooting en Cisco.
- **Ejercicio 4:** Resolución de un escenario de BGP, identificando diferencias entre iBGP y eBGP y aplicando técnicas de depuración.
- **Ejercicio 5:** Análisis de tráfico de red a partir de una captura `.pcap`, entendiendo qué actividad estaba ocurriendo en la red.

Cada uno de estos puntos fue abordado con una mentalidad analítica: **primero entendiendo el problema, luego diseñando la solución y finalmente probando y ajustando donde fuera necesario**.

---

# 📌 Resumen: ¿Cómo abordé este desafío?

Desde el comienzo, supe que la clave para resolver este desafío no era solo ejecutar comandos o escribir código, sino **pensar como un ingeniero de infraestructura**.

🔹 **Automatización con CloudFormation:** No quería desplegar los recursos manualmente, así que me enfoqué en crear plantillas reutilizables y modulares para cada componente de AWS.

🔹 **Redes y conectividad:** En el análisis de VPC Peering vs. Transit Gateway, opté por evaluar costos y escalabilidad, considerando escenarios donde una opción es más viable que la otra.

🔹 **Troubleshooting realista:** En el diagnóstico de redes, no solo ejecuté comandos de Cisco, sino que seguí una metodología ordenada para localizar la falla sin perder tiempo.

🔹 **Entender antes de actuar:** En el ejercicio de BGP, analizé las diferencias entre iBGP y eBGP, entendiendo cómo las decisiones de enrutamiento afectan la conectividad en un entorno híbrido con proveedores cloud.

🔹 **Análisis de tráfico:** En la captura de paquetes `.pcap`, en lugar de solo mirar los datos, me pregunté: *¿qué comportamiento puedo inferir de esta actividad?* Eso me ayudó a sacar conclusiones más precisas.

**No fue solo un desafío técnico, sino un ejercicio de pensamiento crítico, documentación y buenas prácticas en arquitectura cloud.**

---

# 📌 Desenlace

Este desafío me dejó varias lecciones:

👉 **La infraestructura como código es clave:** Automaticé cada componente para que el despliegue fuera rápido, reproducible y libre de errores manuales.
👉 **La conectividad en la nube tiene múltiples enfoques:** No hay una única respuesta correcta, todo depende del contexto (costos, seguridad, escalabilidad).
👉 **El troubleshooting no es ejecutar comandos al azar:** Seguí un método lógico para aislar problemas y encontrar soluciones eficientes.
👉 **Siempre hay margen para mejorar:** Cada iteración me permitió optimizar la configuración, desde ajustes en HAProxy hasta reglas de seguridad en AWS.

En resumen, fue un ejercicio desafiante pero gratificante. No se trató solo de resolver problemas técnicos, sino de **pensar estratégicamente y documentar cada decisión para hacer que la solución fuera entendible y replicable**.