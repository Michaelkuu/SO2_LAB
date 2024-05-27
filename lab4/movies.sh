#!/bin/bash -eu

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
    echo -e "-y YEAR\n\tSearch nowsze niż ROK"  # opcja -y III
}

function print_error () {
    echo -e "\e[31m\033[1m${*}\033[0m" >&2      # Zmieniona @ na * I
}

function get_movies_list () {
    local -r MOVIES_DIR="${1}"
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath ./*)
    echo "${MOVIES_LIST}"
}

function query_title () {
    local -r MOVIES_LIST="${1}"
    local -r QUERY="${2}"

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then  # Cudzysłowie I
            RESULTS_LIST+=("${MOVIE_FILE}")
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    local -r MOVIES_LIST="${1}"
    local -r QUERY="${2}"

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=("${MOVIE_FILE}")                         # Cudzysłowie I
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_year () {                                            # nowa funkcja do year III
    local -r MOVIES_LIST="${1}"
    local -r YEAR="${2}"

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        MOVIE_YEAR=$(grep "| Year" "${MOVIE_FILE}" | awk '{print $3}')
        if [[ "${MOVIE_YEAR}" -gt "${YEAR}" ]]; then
            RESULTS_LIST+=("${MOVIE_FILE}")
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function print_movies () {
    local -r MOVIES_LIST="${1}"
    local -r OUTPUT_FORMAT="${2}"

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}

function print_xml_format () {
    local -r FILENAME="${1}"

    local TEMP
    TEMP=$(cat "${FILENAME}")

    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

while getopts ":hd:t:a:y:f::x" OPT; do                          # Dwa dwukropki, argument opcjonalny? II. dodane y III
    case ${OPT} in
        h)
            print_help
            exit 0
            ;;
        d)
            MOVIES_DIR=${OPTARG}
            ;;
        t)
            SEARCHING_TITLE=true
            QUERY_TITLE=${OPTARG}
            ;;
        f)
            FILE_4_SAVING_RESULTS=${OPTARG:-results.txt}      # :-results.txt  II
            ;;
        a)
            SEARCHING_ACTOR=true
            QUERY_ACTOR=${OPTARG}
            ;;
        y)                                                     
            SEARCHING_YEAR=true                                # nowa opcja dla y III
            QUERY_YEAR=${OPTARG}
            ;;
        x)
            OUTPUT_FORMAT="xml"
            ;;
        \?)
            print_error "ERROR: Invalid option: -${OPTARG}"
            exit 1
            ;;
    esac
done

if [[ ! -d "${MOVIES_DIR}" ]]; then                 # zadanie III
    print_error "ERROR: Podaj -d marvel"
    exit 1
fi

MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

if ${SEARCHING_TITLE:-false}; then                                  # $ zamiast `` I
    MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
fi

if ${SEARCHING_ACTOR:-false}; then
    MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
fi

if ${SEARCHING_YEAR:-false}; then
    MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${QUERY_YEAR}")
fi

if [[ -z "${MOVIES_DIR:-}" ]]; then                 # myślałem nad lt ale z -z działa I.
    print_error "ERROR: Podaj -d marvel"
    exit 1
fi

if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
else
    print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}" | tee "${FILE_4_SAVING_RESULTS:-results.txt}"     # :-results.txt II
fi
