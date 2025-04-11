 Opción 1: Peering de VPCs (Económico y Seguro)
🔹 Mejor opción si el objetivo es minimizar costos y mejorar la seguridad.

✅ Ventajas:

Sin costo adicional por hora (solo pagas el tráfico entre VPCs).

Seguridad alta, ya que el tráfico es privado y no pasa por internet.

Menos configuración que otras soluciones.

🔴 Desventajas:

No escala bien con muchas VPCs (requiere configurar muchas conexiones).

No admite comunicación transitiva (cada VPC debe emparejarse con las otras).

🔧 Implementación con CloudFormation
1️⃣ Configurar VPC Peering entre las tres VPCs
2️⃣ Actualizar tablas de ruteo para permitir tráfico entre ellas