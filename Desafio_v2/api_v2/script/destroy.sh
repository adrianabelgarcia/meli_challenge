#!/bin/bash
STACK_NAME=meli-stack-v2
REGION=us-east-1

echo "⚡️ Eliminando stack $STACK_NAME en $REGION..."

aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION

echo "🕒 Esperando que se elimine..."

aws cloudformation wait stack-delete-complete \
  --stack-name $STACK_NAME \
  --region $REGION

echo "✅ Stack eliminado completamente."
