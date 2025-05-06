#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <IP_Publica_HAProxy>"
    exit 1
fi

IP=$1

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

function test() {
    DESCRIPTION=$1
    COMMAND=$2
    EXPECTED=$3

    echo -n "-> $DESCRIPTION ... "

    RESPONSE=$(eval $COMMAND)
    
    if [[ "$RESPONSE" == *"$EXPECTED"* ]]; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((PASSED++))
    else
        echo -e "${RED}❌ FAILED${NC}"
        echo "    Esperado: $EXPECTED"
        echo "    Obtenido: $RESPONSE"
        ((FAILED++))
    fi
}

echo "======================================"
echo ">>> INICIANDO TESTS EN $IP"
echo "======================================"

# 1 - Estado inicial
test "GET / (Estado OK)" "curl -s http://$IP" '"status": "ok"'

# 2 - Crear recurso
test "POST /json (Crear test1)" "curl -s -X POST -H \"Content-Type: application/json\" -d '{\"id\": \"test1\", \"message\": \"Hello World\"}' http://$IP/json" '"message": "Created"'

# 3 - Obtener recurso creado
test "GET /json/test1 (Debe existir)" "curl -s http://$IP/json/test1" '"id": "test1"'

# 4 - Modificar recurso
test "PUT /json/test1 (Modificar mensaje)" "curl -s -X PUT -H \"Content-Type: application/json\" -d '{\"id\": \"test1\", \"message\": \"Updated Hello\"}' http://$IP/json/test1" '"message": "Updated"'

# 5 - Leer recurso actualizado
test "GET /json/test1 (Verificar actualización)" "curl -s http://$IP/json/test1" '"message": "Updated Hello"'

# 6 - Eliminar recurso
test "DELETE /json/test1 (Eliminar test1)" "curl -s -X DELETE http://$IP/json/test1" '"message": "Deleted"'

# 7 - Verificar eliminación
test "GET /json/test1 (Debe estar eliminado)" "curl -s http://$IP/json/test1" '"error": "Not found"'

echo ""
echo "======================================"
echo ">>> RESULTADO FINAL"
echo "PASADOS: $PASSED"
echo "FALLADOS: $FAILED"
echo "======================================"

if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}✅ TODOS LOS TESTS PASARON${NC}"
else
    echo -e "${RED}❌ ALGUNOS TESTS FALLARON${NC}"
fi
