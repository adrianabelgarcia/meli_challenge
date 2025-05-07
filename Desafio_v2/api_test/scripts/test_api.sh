#!/bin/bash

# Verificar si la URL fue proporcionada como parámetro
if [ -z "$1" ]; then
  echo "❌ Error: Debes proporcionar la URL de la API como parámetro."
  echo "Uso: ./crud_tests.sh <URL>"
  exit 1
fi

# URL base de la API (proporcionada como primer parámetro)
API_URL="$1"

# Crear un recurso (POST)
echo "🚀 Probando Crear (POST) en $API_URL"
curl -X POST "$API_URL/json" \
  -H "Content-Type: application/json" \
  -d '{"id": "1", "name": "Test", "description": "This is a test item"}'
echo -e "\n"

# Leer el estado de la API (GET)
echo "🔍 Probando Leer el estado de la API (GET) en $API_URL"
curl "$API_URL/"
echo -e "\n"

# Leer un recurso por ID (GET)
echo "🔍 Probando Leer un recurso por ID (GET) en $API_URL"
curl "$API_URL/json/1"
echo -e "\n"

# Actualizar un recurso (PUT)
echo "✏️ Probando Actualizar un recurso (PUT) en $API_URL"
curl -X PUT "$API_URL/json/1" \
  -H "Content-Type: application/json" \
  -d '{"id": "1", "name": "Updated Test", "description": "This item has been updated"}'
echo -e "\n"

# Eliminar un recurso (DELETE)
echo "🗑️ Probando Eliminar un recurso (DELETE) en $API_URL"
curl -X DELETE "$API_URL/json/1"
echo -e "\n"

# Intentar crear un recurso sin el campo 'id' (Prueba de error)
echo "❌ Probando Crear sin ID (POST) en $API_URL"
curl -X POST "$API_URL/json" \
  -H "Content-Type: application/json" \
  -d '{"name": "Missing ID", "description": "This item has no ID"}'
echo -e "\n"

# Intentar obtener un recurso que no existe (GET con ID no existente)
echo "❌ Probando Obtener recurso inexistente (GET) en $API_URL"
curl "$API_URL/json/999"
echo -e "\n"
