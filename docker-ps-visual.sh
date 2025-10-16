#!/bin/bash

BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

dps() {
    local SHOW_ALL=false
    
    if [[ "$1" == "-a" ]]; then
        SHOW_ALL=true
    fi
    
    if [ "$SHOW_ALL" = true ]; then
        TOTAL=$(docker ps -a -q | wc -l)
        RUNNING=$(docker ps -q | wc -l)
        STOPPED=$((TOTAL - RUNNING))
        CMD="docker ps -a"
    else
        TOTAL=$(docker ps -q | wc -l)
        RUNNING=$TOTAL
        STOPPED=0
        CMD="docker ps"
    fi
    
    if [ "$TOTAL" -eq 0 ]; then
        echo -e "${CYAN}┌─────────────────────────────────────────────────────┐${NC}"
        echo -e "${CYAN}│${WHITE}            🐳 DOCKER CONTAINERS                 ${CYAN}│${NC}"
        echo -e "${CYAN}├─────────────────────────────────────────────────────┤${NC}"
        echo -e "${CYAN}│${YELLOW}  No hay contenedores                               ${CYAN}│${NC}"
        echo -e "${CYAN}└─────────────────────────────────────────────────────┘${NC}"
        return
    fi
    
    if [ "$SHOW_ALL" = true ]; then
        echo -e "\n${WHITE}🐳 DOCKER CONTAINERS${NC} ${GRAY}(Total: ${CYAN}$TOTAL${GRAY} | ${GREEN}$RUNNING${GRAY} activos | ${RED}$STOPPED${GRAY} detenidos)${NC}\n"
    else
        echo -e "\n${WHITE}🐳 DOCKER CONTAINERS${NC} ${GRAY}(${GREEN}$TOTAL${GRAY} activos)${NC}\n"
    fi
    
    $CMD --format "{{.Names}}|{{.Image}}|{{.ID}}|{{.Status}}|{{.Ports}}" | while IFS='|' read -r name image id status ports; do
        echo -e "${CYAN}┌──────────────────────────────────────────────────────────────────────┐${NC}"
        
        if [[ $status == *"Up"* ]]; then
            status_color=$GREEN
            status_icon="✓"
            name_icon="📦"
        elif [[ $status == *"Exited"* ]]; then
            status_color=$RED
            status_icon="✗"
            name_icon="⏹️ "
        elif [[ $status == *"Paused"* ]]; then
            status_color=$YELLOW
            status_icon="⏸"
            name_icon="⏸️ "
        else
            status_color=$GRAY
            status_icon="○"
            name_icon="📦"
        fi
        
        if [[ $status == *"Up"* ]]; then
            echo -e "${CYAN}│${NC} ${BLUE}$name_icon $name${NC}"
        else
            echo -e "${CYAN}│${NC} ${GRAY}$name_icon $name${NC}"
        fi
        
        echo -e "${CYAN}│${NC} ${GRAY}├─${NC} ${WHITE}Imagen:${NC} ${MAGENTA}$image${NC}"
        
        id_short=$(echo "$id" | cut -c1-12)
        echo -e "${CYAN}│${NC} ${GRAY}├─${NC} ${WHITE}ID:${NC} ${YELLOW}$id_short${NC}"
        
        echo -e "${CYAN}│${NC} ${GRAY}├─${NC} ${WHITE}Estado:${NC} ${status_color}$status_icon $status${NC}"
        
        if [[ $status == *"Up"* ]]; then
            if [ -z "$ports" ]; then
                echo -e "${CYAN}│${NC} ${GRAY}└─${NC} ${WHITE}Puertos:${NC} ${GRAY}-${NC}"
            else
                echo -e "${CYAN}│${NC} ${GRAY}└─${NC} ${WHITE}Puertos:${NC}"
                echo "$ports" | tr ',' '\n' | while read -r port; do
                    [ -n "$port" ] && echo -e "${CYAN}│${NC}    ${GREEN}→${NC} ${GREEN}$(echo $port | xargs)${NC}"
                done
            fi
        else
            echo -e "${CYAN}│${NC} ${GRAY}└─${NC} ${WHITE}Puertos:${NC} ${GRAY}N/A${NC}"
        fi
        
        echo -e "${CYAN}└──────────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
    done
    
    echo -e "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

dps "$@"
