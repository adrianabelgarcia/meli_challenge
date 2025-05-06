
# Infraestructura con ALB Multi-AZ + CloudFront + Backend API en AutoScaling + SSM

Este proyecto configura una infraestructura de alta disponibilidad y escalabilidad automática en AWS utilizando **CloudFormation**. La arquitectura incluye un **Application Load Balancer (ALB)** distribuido en múltiples zonas de disponibilidad (AZ), un **CloudFront Distribution** para optimizar la entrega del contenido, un **Backend API en AutoScaling**, y **SSM** para gestionar las instancias EC2 sin necesidad de acceso directo por SSH.

## Descripción

La infraestructura está diseñada para manejar aplicaciones de backend que requieren alta disponibilidad, escalabilidad y seguridad, mientras que el acceso a los servidores se gestiona de manera eficiente mediante **AWS Systems Manager (SSM)**. El tráfico hacia el backend se distribuye mediante el ALB, y **CloudFront** acelera la entrega del contenido a los usuarios finales.

## Componentes creados:

### 1. **VPC (Virtual Private Cloud)**

- **Propósito**: Aísla toda la infraestructura en una red privada dentro de AWS. Configura un bloque CIDR (`10.0.0.0/16`).
- **Beneficio**: Proporciona un entorno seguro y aislado para desplegar las instancias y otros recursos.

```yaml
VPC:
  Type: AWS::EC2::VPC
  Properties:
    EnableDnsSupport: true
    EnableDnsHostnames: true
    CidrBlock: !FindInMap [SubnetConfig, VPC, CIDR]
```
### 2. **Subredes Públicas y Privadas**

- **Subredes Públicas**: Se crean dos subredes en dos zonas de disponibilidad diferentes para garantizar alta disponibilidad. Estas subredes están configuradas para permitir direcciones IP públicas y acceso a Internet.
- **Subredes Privadas**: Las subredes privadas son donde se lanzan las instancias del backend (EC2) y están configuradas para no tener acceso directo a Internet.

```yaml
PublicSubnetAZ1:
  Type: AWS::EC2::Subnet
  Properties:
    VpcId: !Ref VPC
    CidrBlock: 10.0.1.0/24
    AvailabilityZone: !Select [ 0, !GetAZs "" ]
    MapPublicIpOnLaunch: true
```

### 3. **Internet Gateway y Attachments**

- **Internet Gateway**: Permite que las instancias en las subredes públicas accedan a Internet.
- **Adjuntar al VPC**: Se adjunta el Internet Gateway a la VPC para habilitar el tráfico de salida hacia Internet.

```yaml
InternetGateway:
  Type: AWS::EC2::InternetGateway

AttachGateway:
  Type: AWS::EC2::VPCGatewayAttachment
  Properties:
    VpcId: !Ref VPC
    InternetGatewayId: !Ref InternetGateway
```

### 4. **Security Groups**

- **BackendSecurityGroup**: Permite tráfico HTTP (puerto 5000) desde el ALB hacia las instancias EC2 backend.
- **EFSSecurityGroup**: Permite tráfico NFS (puerto 2049) entre las instancias EC2 y el sistema de archivos EFS.
- **HAProxySecurityGroup**: Permite tráfico HTTP desde Internet hacia el ALB.

```yaml
BackendSecurityGroup:
  Type: AWS::EC2::SecurityGroup
  Properties:
    GroupDescription: Allow HTTP from ALB
    VpcId: !Ref VPC
    SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 5000
        ToPort: 5000
        CidrIp: 0.0.0.0/0
```

### 5. **EFS (Elastic File System)**

- **EFSFileSystem**: Proporciona almacenamiento compartido entre las instancias EC2 del backend.
- **EFSMountTarget**: Permite que las instancias EC2 monten el sistema de archivos EFS.

```yaml
EFSFileSystem:
  Type: AWS::EFS::FileSystem
  Properties:
    Encrypted: true
    PerformanceMode: generalPurpose
```

### 6. **IAM Role e Instance Profile**

- **IAM Role**: Permite que las instancias EC2 asuman el rol necesario para interactuar con otros servicios de AWS, como SSM y CloudWatch.
- **Instance Profile**: Asocia el rol IAM a las instancias EC2 para otorgarles permisos adecuados.

```yaml
InstanceProfileRole:
  Type: AWS::IAM::Role
  Properties:
    AssumeRolePolicyDocument:
      Version: "2012-10-17"
      Statement:
        - Effect: Allow
          Principal:
            Service:
              - ec2.amazonaws.com
          Action: sts:AssumeRole
    ManagedPolicyArns:
      - arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
      - arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess
      - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
```

### 7. **Auto Scaling Group (ASG) para Backend API**

- **BackendLaunchTemplate**: Define el template para lanzar las instancias EC2 del backend con una configuración básica.
- **BackendAutoScalingGroup**: Configura el grupo de escalado automático para lanzar instancias EC2 en las subredes privadas. El número de instancias puede escalar de acuerdo a la carga.

```yaml
BackendLaunchTemplate:
  Type: AWS::EC2::LaunchTemplate
  Properties:
    LaunchTemplateData:
      InstanceType: t2.micro
      ImageId: ami-0c02fb55956c7d316
      KeyName: access_test
      IamInstanceProfile:
        Name: !Ref InstanceProfile
      SecurityGroupIds:
        - !Ref BackendSecurityGroup
```

### 8. **Application Load Balancer (ALB)**

- **ALB**: Distribuye el tráfico HTTP entre las instancias EC2 en el Auto Scaling Group.
- **Health Checks**: El ALB realiza verificaciones de estado en las instancias EC2 para asegurarse de que estén saludables antes de redirigir el tráfico hacia ellas.

```yaml
ApplicationLoadBalancer:
  Type: AWS::ElasticLoadBalancingV2::LoadBalancer
  Properties:
    Subnets:
      - !Ref PublicSubnetAZ1
      - !Ref PublicSubnetAZ2
    SecurityGroups:
      - !Ref ALBSecurityGroup
    Scheme: internet-facing
```

### 9. **CloudFront**

- **CloudFront**: Distribuye el contenido de la API desde el ALB, mejorando la latencia y la velocidad de entrega.
- **Cache Policy**: Configura políticas para evitar la caché y garantizar que siempre se sirvan los datos más recientes.

```yaml
CloudFrontDistribution:
  Type: AWS::CloudFront::Distribution
  Properties:
    DistributionConfig:
      Enabled: true
      Origins:
        - DomainName: !GetAtt ApplicationLoadBalancer.DNSName
          Id: ALBOrigin
          CustomOriginConfig:
            HTTPPort: 80
            OriginProtocolPolicy: http-only
      DefaultCacheBehavior:
        TargetOriginId: ALBOrigin
        ViewerProtocolPolicy: allow-all
```

### 10. **Outputs**

- **ALBDNSName**: Proporciona el DNS del **Application Load Balancer**.
- **CloudFrontURL**: Proporciona la URL pública de **CloudFront** para acceder a la API.

```yaml
ALBDNSName:
  Description: DNS del Application Load Balancer
  Value: !GetAtt ApplicationLoadBalancer.DNSName
  Export:
    Name: ALBDNSName

CloudFrontURL:
  Description: URL de CloudFront
  Value: !GetAtt CloudFrontDistribution.DomainName
  Export:
    Name: CloudFrontURL
```

## Topología de la Infraestructura

La infraestructura está diseñada para ser **multi-AZ** y está compuesta por los siguientes componentes clave:

- **VPC** con subredes públicas y privadas distribuidas en al menos 2 zonas de disponibilidad (AZs).
- **Internet Gateway** para acceso público a las instancias que lo necesiten.
- **Application Load Balancer (ALB)** para distribuir el tráfico HTTP de manera eficiente entre las instancias EC2.
- **Auto Scaling Group (ASG)** para gestionar las instancias backend de forma escalable.
- **CloudFront** como capa de caché y distribución del contenido hacia los usuarios finales.
- **EFS** para almacenamiento compartido entre las instancias EC2.

La **topología** es la siguiente:

```
   +----------------+       +----------------+      +----------------+
   |    Internet    | ----> |  Application   | <--> |  Backend API   |
   |                |       |  Load Balancer |      |   Instances    |
   +----------------+       +----------------+      +----------------+
                                   |
                           +---------------+
                           | CloudFront    |
                           +---------------+
```

La **estructura** permite que el tráfico llegue al **ALB**, que lo distribuye entre las instancias EC2 backend. **CloudFront** mejora la entrega del contenido hacia el cliente, mientras que **EFS** asegura que todos los datos estén compartidos de manera eficiente entre las instancias EC2.

