#!/usr/bin/env bash
# docker-ps-visual — dps / dpa / dpr / dpar
#   -a  incluye detenidos      -r  vista resumen (tabla)

e=$'\e'
R="${e}[0m"; B="${e}[1m"
fg() { printf '%s[1;38;2;%d;%d;%dm' "$e" "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }
BORDE=$(fg 7FB4CA); BLANCO=$(fg FFFFFF); VERDE=$(fg A6E36E); ROJO=$(fg FF6B6B)
AMARILLO=$(fg FFC66D); CELESTE=$(fg 8FD3FF); GRIS=$(fg C8C8C8)

SHOW_ALL=false; SHOW_RESUME=false
for a in "$@"; do
    case $a in
        -a) SHOW_ALL=true ;; -r) SHOW_RESUME=true ;;
        -ar|-ra) SHOW_ALL=true; SHOW_RESUME=true ;;
    esac
done
command -v jq >/dev/null || { echo "docker-ps-visual: falta jq"; exit 1; }

ANSI_RE=$'\e\\[[0-9;]*m'
largo() { local s=$1; while [[ $s =~ $ANSI_RE ]]; do s=${s//"${BASH_REMATCH[0]}"/}; done; echo "${#s}"; }
pad()   { local n; n=$(largo "$1"); printf '%s%*s' "$1" $(( $2 > n ? $2 - n : 0 )) ''; }
rep()   { local i; for (( i=0; i<$2; i++ )); do printf '%s' "$1"; done; }

if $SHOW_ALL; then mapfile -t IDS < <(docker ps -aq); else mapfile -t IDS < <(docker ps -q); fi
TOTAL=$(docker ps -aq | wc -l); ACTIVOS=$(docker ps -q | wc -l); DETENIDOS=$((TOTAL - ACTIVOS))

echo
if $SHOW_ALL; then
    echo -e "${BLANCO}🐳 RESUMEN DOCKER${R}  ${GRIS}Total: ${CELESTE}${TOTAL}${GRIS} | ${VERDE}${ACTIVOS} activos${GRIS} | ${ROJO}${DETENIDOS} detenidos${R}"
else
    echo -e "${BLANCO}🐳 RESUMEN DOCKER${R}  ${VERDE}${ACTIVOS} activos${R}"
fi
echo
(( ${#IDS[@]} == 0 )) && { echo -e "  ${AMARILLO}No hay contenedores${R}\n"; exit 0; }

# nombre|estado|codigo_salida|imagen|puertos   (puertos: "ext>int,..." ; ext vacío = no publicado)
JQ='.[] |
(.NetworkSettings.Ports // {}) as $p |
([ $p | to_entries[] | .key as $k | (.value // [])[] | select((.HostIp // "") | test(":") | not)
   | "\(.HostPort)>\($k | split("/")[0])" ] | unique) as $pub |
([ (.Config.ExposedPorts // {} | keys[]), ($p | keys[]) ] | unique
   | map(select(. as $k | ($p[$k] // null) == null) | split("/")[0])) as $exp |
(if .HostConfig.NetworkMode == "host" then [ $exp[] | "\(.)>\(.)" ] else [ $exp[] | ">\(.)" ] end) as $rest |
[ (.Name | ltrimstr("/")), .State.Status, (.State.ExitCode | tostring), .Config.Image,
  (($pub + $rest) | join(",")) ] | join("|")'
mapfile -t FILAS < <(docker inspect "${IDS[@]}" | jq -r "$JQ" | sort)

puertos() {  # "ext>int,..." -> una línea por puerto
    local it ext int
    IFS=',' read -ra P <<<"$1"
    (( ${#P[@]} == 0 )) && { echo "${GRIS}-"; return; }
    for it in "${P[@]}"; do
        ext=${it%%>*}; int=${it#*>}
        if [[ -n $ext ]]; then echo "${AMARILLO}${ext} ${GRIS}→ ${CELESTE}${int}"
        else echo "${GRIS}  - → ${CELESTE}${int}"; fi
    done
}

estado() {  # estado codigo
    case $1 in
        running)    echo "${VERDE}✓ Activo" ;;
        paused)     echo "${AMARILLO}⏸ Pausado" ;;
        restarting) echo "${AMARILLO}↻ Reiniciando" ;;
        exited)     [[ $2 == 0 ]] && echo "${ROJO}✗ Detenido" || echo "${ROJO}✗ Error ($2)" ;;
        *)          echo "${GRIS}○ $1" ;;
    esac
}

# ── anchos según el contenido ──
WN=6; WE=14; WP=17
for f in "${FILAS[@]}"; do
    IFS='|' read -r n _ _ _ p <<<"$f"
    (( ${#n} > WN )) && WN=${#n}
    while read -r l; do l=$(largo "$l"); (( l > WP )) && WP=$l; done < <(puertos "$p")
done

if $SHOW_RESUME; then
    linea() { echo -e "${BORDE}$1$(rep ─ $((WN+2)))$2$(rep ─ $((WE+2)))$2$(rep ─ $((WP+2)))$3${R}"; }
    fila()  { echo -e "${BORDE}│${R} $(pad "$1" $WN) ${BORDE}│${R} $(pad "$2" $WE) ${BORDE}│${R} $(pad "$3" $WP) ${BORDE}│${R}"; }

    grupo() {  # titulo filtro
        local sel=() f n st xc img p
        for f in "${FILAS[@]}"; do
            IFS='|' read -r n st _ <<<"$f"
            case $2 in
                activos)   [[ $st == running || $st == restarting || $st == paused ]] ;;
                detenidos) [[ $st != running && $st != restarting && $st != paused ]] ;;
            esac && sel+=("$f")
        done
        (( ${#sel[@]} == 0 )) && return
        echo -e "$1 ${GRIS}(${#sel[@]})${R}\n"
        linea ┌ ┬ ┐
        fila "${BLANCO}NOMBRE" "${BLANCO}ESTADO" "${BLANCO}PUERTOS ${GRIS}ext → int"
        linea ├ ┼ ┤
        for f in "${sel[@]}"; do
            IFS='|' read -r n st xc img p <<<"$f"
            local nom est k pl
            mapfile -t pl < <(puertos "$p")
            [[ $st == running ]] && nom="${BLANCO}${n}" || nom="${GRIS}${n}"
            est=$(estado "$st" "$xc")
            for (( k=0; k<${#pl[@]}; k++ )); do
                (( k == 0 )) && fila "$nom" "$est" "${pl[k]}" || fila "" "" "${pl[k]}"
            done
        done
        linea └ ┴ ┘
        echo
    }
    grupo "${VERDE}🟢 ACTIVOS${R}" activos
    grupo "${ROJO}🔴 DETENIDOS${R}" detenidos
else
    for f in "${FILAS[@]}"; do
        IFS='|' read -r n st xc img p <<<"$f"
        [[ $st == running ]] && echo -e "${BORDE}┌─${R} 📦 ${BLANCO}${n}${R}" || echo -e "${BORDE}┌─${R} ⏹️  ${GRIS}${n}${R}"
        echo -e "${BORDE}│${R}  ${GRIS}Imagen:  ${CELESTE}${img}${R}"
        echo -e "${BORDE}│${R}  ${GRIS}Estado:  $(estado "$st" "$xc")${R}"
        first=true
        while read -r l; do
            $first && echo -e "${BORDE}│${R}  ${GRIS}Puertos: ${l}${R}" || echo -e "${BORDE}│${R}           ${l}${R}"
            first=false
        done < <(puertos "$p")
        echo -e "${BORDE}└─${R}\n"
    done
fi
