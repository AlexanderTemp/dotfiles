#!/usr/bin/env python3
"""Tipo de cambio oficial USD/BOB (Banco Central de Bolivia). Actualización 1 vez al día. 

Página pública sin key ni SOAP -- solo HTML plano:
  https://www.bcb.gob.bo/bcb_tco_publico_ultima_cotizacion.php

"""
import json
import re
import urllib.error
import urllib.request

URL = "https://www.bcb.gob.bo/bcb_tco_publico_ultima_cotizacion.php"
HEADER, DIM = "#61afef", "#5c6370"


def fetch():
    req = urllib.request.Request(URL, headers={"User-Agent": "dotfiles-bcbrate"})
    with urllib.request.urlopen(req, timeout=5) as resp:
        return resp.read().decode("utf-8")


def main():
    try:
        html = fetch()
    except (urllib.error.URLError, TimeoutError, OSError):
        print(json.dumps({"text": "⚠ BOB sin datos", "tooltip": "BCB no respondió", "class": "error"}))
        return

    current_m = re.search(r'tco-public-value">Bs ([\d,]+)/\$us', html)
    vigencia_m = re.search(r"VIGENCIA:\s*([^<]+)", html)
    if not current_m:
        print(json.dumps({"text": "⚠ BOB sin datos", "tooltip": "No se pudo parsear BCB", "class": "error"}))
        return

    current = current_m.group(1)
    vigencia = vigencia_m.group(1).strip() if vigencia_m else ""

    MESES = {
        "enero": "ene", "febrero": "feb", "marzo": "mar", "abril": "abr",
        "mayo": "may", "junio": "jun", "julio": "jul", "agosto": "ago",
        "septiembre": "sep", "octubre": "oct", "noviembre": "nov", "diciembre": "dic",
    }

    rows = re.findall(r"<tr><td>([^<]+)</td><td>([\d,]+)</td></tr>", html)
    last28 = rows[-28:]

    text = f"BOB {current}"

    cortas, valores = [], []
    for fecha, valor in last28:
        m = re.search(r"(\d{1,2}) de (\w+)", fecha)
        corta = f"{m.group(1)}{MESES.get(m.group(2), m.group(2)[:3])}" if m else fecha
        cortas.append(corta)
        valores.append(valor)

    POR_FILA = 7
    col_w = max(len(c) for c in cortas + valores) + 2

    header = f"<span font_weight='bold' foreground='{HEADER}'>USD/BOB oficial</span>"
    sep = f"<span foreground='{DIM}'>{'─' * (col_w * POR_FILA)}</span>"

    hist_lines = []
    for i in range(0, len(cortas), POR_FILA):
        chunk_c = cortas[i:i + POR_FILA]
        chunk_v = valores[i:i + POR_FILA]
        if i > 0:
            hist_lines.append(sep)
        hist_lines.append("".join(f"{c:<{col_w}}" for c in chunk_c))
        hist_lines.append(f"<span foreground='{HEADER}'>{''.join(f'{v:<{col_w}}' for v in chunk_v)}</span>")
    actual = f"<span foreground='{DIM}'>Vigente {vigencia}: Bs {current}/$us</span>"

    tooltip_body = "\n".join([header, sep, *hist_lines, sep, actual])
    tooltip = f"<span font_family='FantasqueSansM Nerd Font Mono'>{tooltip_body}</span>"

    print(json.dumps({"text": text, "tooltip": tooltip, "class": "ok"}))


if __name__ == "__main__":
    main()
