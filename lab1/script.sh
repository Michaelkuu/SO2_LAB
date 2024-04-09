#!/bin/bash

SOURCE_DIR=${1:-lab_uno}
RM_LIST=${2:-2remove}
TARGET_DIR=${3:-bakap}

if [[ ! -d "${TARGET_DIR}" ]]; then
    mkdir "${TARGET_DIR}"
    echo "Jeśli ${TARGET_DIR} nie istniał to już istnieje"
fi

if [[ -f "${RM_LIST}" ]]; then
    while IFS= read -r FILE_NAME; do
        FILE_PATH="${SOURCE_DIR}/${FILE_NAME}"
        if [[ -f "${FILE_PATH}" ]]; then
            rm -rf "${FILE_PATH}"
            echo "Usunięty plik: ${FILE_NAME}"
        else
            echo "W katalogu ${SOURCE_DIR} nie ma pliku ${FILE_NAME}"
        fi
    done < "${RM_LIST}"
else
    echo "Brak plików do usunięcia"
fi    

for FILE_NAME in "${SOURCE_DIR}"/*; do
    if [[ -f "${FILE_NAME}" ]]; then
        mv "${FILE_NAME}" "${TARGET_DIR}"
    fi

    if [[ -d "${FILE_NAME}" ]]; then
        cp -r "${FILE_NAME}" "${TARGET_DIR}"
    fi
done

COUNTER=$( find "${SOURCE_DIR}" -maxdepth 1 -type f | wc -l )

if [[ "${COUNTER}" -gt 0 ]]; then
    echo "Jeszcze cos zostało"
fi

if [[ "${COUNTER}" -ge 2 ]]; then
    echo "Zostały co najmniej 2 pliki"
fi

if [[ "${COUNTER}" -gt 4 ]]; then
    echo "Zostało wiecej niż 4 pliki"
fi

if [[ "${COUNTER}" -ge 2 && "${COUNTER}" -le 4 ]]; then
    echo "Zostało coś między 2 a 4, któż to wie"
fi

if [[ "${COUNTER}" -eq 0 ]]; then
    echo "Konon tu był :D"
fi

DATA="$( date +%Y-%m-%d )"

ZIP="bakap_${DATA}.zip"

zip -r "${ZIP}" "${TARGET_DIR}"