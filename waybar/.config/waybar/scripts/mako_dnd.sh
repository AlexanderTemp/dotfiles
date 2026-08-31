#!/usr/bin/env bash
# Estado + toggle de Do Not Disturb para mako, consumido por el modulo
# custom/notifications de waybar (return-type json). El modo "do-not-disturb"
# esta definido en mako/.config/mako/config ([mode=do-not-disturb] invisible=1).
# Iconos Material Design (md-bell_ring / md-bell_off, via el fallback
# "Symbols Nerd Font Mono" en waybar/style.css) en vez de emoji: un emoji
# trae su color fijo y el CSS de waybar no lo puede recolorear, estos si.
BELL="󰂞"
BELL_OFF="󰂛"

if makoctl mode | grep -q do-not-disturb; then
    printf '{"text":"%s","class":"dnd","tooltip":"Notificaciones en pausa -- click para reanudar"}\n' "$BELL_OFF"
else
    printf '{"text":"%s","class":"active","tooltip":"Notificaciones activas -- click para pausar"}\n' "$BELL"
fi
