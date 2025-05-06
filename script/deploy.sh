#!/bin/bash

STACK_NAME="api-unificado-stack"
TEMPLATE_FILE="./cloudformation/unified_stack.yml"
REGION="us-east-1"

echo "🚀 Desplegando stack $STACK_NAME en $REGION..."
aws cloudformation deploy \
    --template-file "$TEMPLATE_FILE" \
    --stack-name "$STACK_NAME" \
    --capabilities CAPABILITY_NAMED_IAM \
    --region "$REGION"

echo "✅ Despliegue completado."
PUBLIC_IP=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='HAProxyPublicIP'].OutputValue" --output text --region "$REGION")

echo "✅ HAProxy disponible en: http://$PUBLIC_IP"

