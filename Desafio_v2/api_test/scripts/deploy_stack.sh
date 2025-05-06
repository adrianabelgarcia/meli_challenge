#!/bin/bash

set -e

STACK_NAME="meli-stack-api"
TEMPLATE_FILE="cloudformation/cf_template.yml"
REGION="us-east-1"  # Cambia la región según sea necesario

echo "🚀 Desplegando stack '$STACK_NAME' en región $REGION..."
aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region "$REGION"

# Obtener la IP pública de HAProxy
PUBLIC_IP=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='HAProxyPublicIP'].OutputValue" --output text --region "$REGION")

echo "✅ HAProxy disponible en: http://$PUBLIC_IP"
