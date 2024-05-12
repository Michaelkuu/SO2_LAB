#!/bin/bash
set -eu

usage() {
    echo "Uzycie: $0 <FOLDER_ZRODLOWY> <FOLDER_DOCELOWY>"
    exit 1
}

if [[ "$#" -ne 2 ]]; then
    echo "Wymagane są dwa argumenty"
    usage
fi

SOURCE_DIR=$1
TARGET_DIR=$2

if [[ ! -d "${SOURCE_DIR}" ]]; then
    echo "Nie ma takiego folderu źródłowego"
    exit 2
fi

if [[ ! -d "${TARGET_DIR}" ]]; then
    echo "Nie ma takiego folderu docelowego"
    exit 2
fi

for ITEM in "${SOURCE_DIR}"/; do
    BASE_NAME=$(basename -- "${ITEM}")
    if [[ -d "${ITEM}" ]]; then
        echo "${ITEM} jest katalogiem"
    elif [[ -L "${ITEM}" ]]; then
        echo "${ITEM} jest dowiazaniem symbolicznym"
    elif [[ -f "${ITEM}" ]]; then
        echo "${ITEM} jest regularnym plikiem"
    else
        echo "${ITEM} jest nieznanym typem pliku"
    fi

    if [[ -d "${ITEM}" ]] || [[ -f "${ITEM}" ]]; then
        if [[ "${BASE_NAME}" == .* ]]; then
            EXTENSION="${BASE_NAME##.}"
            NAME="${BASE_NAME%.}"
            TARGET_NAME="${NAME^^}_ln.${EXTENSION}"
        else
            EXTENSION=""
            TARGET_NAME="${BASE_NAME^^}_ln"
        fi
        ln -s "$(realpath -- "${ITEM}")" "${TARGET_DIR}/${TARGET_NAME}"
    fi
done