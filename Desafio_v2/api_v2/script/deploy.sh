#!/bin/bash

STACK_NAME=meli-stack-v2
REGION=us-east-1
TEMPLATE_FILE=cloudformation/infraestructura.yaml

echo "🚀 Desplegando stack $STACK_NAME en $REGION..."

aws cloudformation deploy \
  --stack-name $STACK_NAME \
  --template-file $TEMPLATE_FILE \
  --region $REGION \
  --capabilities CAPABILITY_NAMED_IAM

if [ $? -eq 0 ]; then
  echo "✅ Despliegue completado."

  # Capturar el DNS del Load Balancer
  ALB_DNS=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --query "Stacks[0].Outputs[?OutputKey=='ALBDNSName'].OutputValue" \
    --output text)

  # Capturar el DNS de CloudFront
  CLOUDFRONT_URL=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --query "Stacks[0].Outputs[?OutputKey=='CloudFrontURL'].OutputValue" \
    --output text)

  echo "👉 URL del Load Balancer: $ALB_DNS"
  echo "👉 URL de CloudFront: $CLOUDFRONT_URL"

else
  echo "❌ Error en el despliegue"
  exit 1
fi
