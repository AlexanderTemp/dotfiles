#!/usr/bin/env bash
BELL="󰂞"
BELL_OFF="󰂛"

if makoctl mode | grep -q do-not-disturb; then
    printf '{"text":"%s","class":"dnd","tooltip":"Notificaciones en pausa -- click para reanudar"}\n' "$BELL_OFF"
else
    printf '{"text":"%s","class":"active","tooltip":"Notificaciones activas -- click para pausar"}\n' "$BELL"
fi
