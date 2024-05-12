#!/bin/bash

set -eu

DIRECTORY="${1:-test}"

if [[ ! -d "${DIRECTORY}" ]]; then
    echo "Katalog nie istnieje...."
    exit 1
fi

if [[ $# -eq 0 ]]; then
    echo "Nie ma parametru...."
    exit 2
fi

find "$DIRECTORY" -type f -name "*.bak" -exec chmod u-w,o-w {} \;   # odbiera edytowanie dla włąścicieli i innych
find "$DIRECTORY" -type d -name "*.bak" -exec chmod 0111 {} \;      # tylko inni mogą wchodzić do .bak
find "$DIRECTORY" -type d -name "*.tmp" -exec chmod 1777 {} \;      # tworzenie i usuwanie tylko swoich plików
find "$DIRECTORY" -type f -name "*.txt" -exec chmod 0460 {} \;      # czytają właściciele, edytuje grupa, wykonują inni
find "$DIRECTORY" -type f -name "*.exe" -exec chmod 4755 {} \;      # wykonują wszyscy, ale zawsze wykonują się z uprawnieniami właściciela

echo "Koniec kłopotów Najmana v2 (chyba (znowu))"