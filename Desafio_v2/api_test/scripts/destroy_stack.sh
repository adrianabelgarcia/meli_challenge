#!/bin/bash

set -e

STACK_NAME="HAProxyBackendStack"
REGION="us-east-1"

echo "⚡ Eliminando stack '$STACK_NAME' en región $REGION..."
aws cloudformation delete-stack \
  --stack-name "$STACK_NAME" \
  --region "$REGION"

echo "⏳ Esperando a que la eliminación termine..."
aws cloudformation wait stack-delete-complete \
  --stack-name "$STACK_NAME" \
  --region "$REGION"

echo "✅ Stack eliminado exitosamente."
