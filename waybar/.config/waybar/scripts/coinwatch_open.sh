#!/usr/bin/env bash
# Click en el módulo de coinwatch -> elegís una moneda con fuzzel -> se abre
# su página en CoinGecko. Duplica los labels/ids de coinwatch.py a propósito
# (mantener cada script independiente y chico gana sobre compartir estado
# entre un .py y un .sh) -- si agregás una moneda al watchlist, sumala acá
# también si querés que aparezca en este picker.
declare -A IDS=(
    [BTC]=bitcoin
    [ETH]=ethereum
    [XRP]=ripple
    [BNB]=binancecoin
    [SUI]=sui
)

choice=$(printf '%s\n' "${!IDS[@]}" | sort | fuzzel --dmenu --prompt="CoinGecko: ")
[ -z "$choice" ] && exit 0

id="${IDS[$choice]}"
[ -n "$id" ] && xdg-open "https://www.coingecko.com/en/coins/$id"
