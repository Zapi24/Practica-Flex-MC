#!/bin/bash

# Verifica si el archivo Flex existe
if [ ! -f "plantilla.l" ]; then
    echo "Error: El archivo plantilla.l no existe en el directorio actual."
    exit 1
fi

# Paso 1: Generar el archivo lex.yy.cc con flex++
echo "Generando archivo lex.yy.cc..."
flex++ plantilla.l
if [ $? -ne 0 ]; then
    echo "Error al generar lex.yy.cc con flex++."
    exit 1
fi

# Paso 2: Compilar el programa con g++
echo "Compilando el programa..."
g++ lex.yy.cc -o prog
if [ $? -ne 0 ]; then
    echo "Error al compilar el programa con g++."
    exit 1
fi

# Paso 3: Ejecutar el programa con un archivo de entrada
echo "Ejecutando el programa..."
if [ $# -eq 1 ]; then
    ./prog "$1"
else
    echo "Error: No se especificó un archivo de entrada. Uso: ./compilar_y_ejecutar.sh <archivo_entrada>"
    exit 1
fi
