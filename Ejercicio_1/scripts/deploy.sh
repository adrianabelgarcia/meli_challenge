#!/bin/bash

# Crear la infraestructura con CloudFormation
aws cloudformation create-stack --stack-name api-vpc --template-body file://vpc.yml --capabilities CAPABILITY_NAMED_IAM
aws cloudformation create-stack --stack-name api-security --template-body file://security_groups.yml --capabilities CAPABILITY_NAMED_IAM
aws cloudformation create-stack --stack-name api-efs --template-body file://efs.yml --capabilities CAPABILITY_NAMED_IAM
aws cloudformation create-stack --stack-name api-haproxy --template-body file://haproxy.yml --capabilities CAPABILITY_NAMED_IAM
aws cloudformation create-stack --stack-name api-ec2 --template-body file://ec2.yml --capabilities CAPABILITY_NAMED_IAM

# Verificar el despliegue
echo "Infraestructura desplegada correctamente."
