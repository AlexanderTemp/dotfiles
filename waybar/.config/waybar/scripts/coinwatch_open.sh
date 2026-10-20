#!/usr/bin/env bash
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
