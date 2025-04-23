#!/bin/bash

# Nombre del stack
STACK_NAME="meli-api-stack"

# Ruta al template
TEMPLATE_FILE="cloudformation/CFTemplate.yml"

# Región por defecto (puedes cambiarla)
REGION="us-east-1"

# Verificar que AWS CLI esté configurado
if ! aws sts get-caller-identity &> /dev/null; then
  echo "❌ AWS CLI no está configurado. Ejecuta 'aws configure' primero."
  exit 1
fi

# Crear el stack
echo "🚀 Desplegando stack '$STACK_NAME' en región $REGION..."
aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region "$REGION"

# Verificar si el stack fue creado correctamente
if [ $? -eq 0 ]; then
  echo "✅ Stack '$STACK_NAME' desplegado con éxito."
else
  echo "❌ Error al desplegar el stack."
  exit 1
fi
