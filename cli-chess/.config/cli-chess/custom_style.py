# This file is used to override the default style of cli-chess. It must be kept in dictionary format.
# Colors are expected to be HTML color names (e.g. seagreen) or HTML hex colors (e.g. #2E8B57)
# Restarting cli-chess or pressing [CTRL+R] on any screen will force a style refresh.
# Visit the cli-chess github page (https://github.com/trevorbayless/cli-chess/) for more styling information.

# Tablero discreto: casillas casi del color del fondo de kitty (#1F1F28) y piezas apagadas.
# Piezas blancas #a9a596, negras #5f5f75; cada clase de casilla las repite porque el
# estilo por defecto las define por casilla.

{
    "rank-label": "fg:#3a3a46",
    "file-label": "fg:#3a3a46",

    "light-square": "bg:#2a2a35",
    "light-square.light-piece": "fg:#a9a596",
    "light-square.dark-piece": "fg:#5f5f75",

    "dark-square": "bg:#23232d",
    "dark-square.light-piece": "fg:#a9a596",
    "dark-square.dark-piece": "fg:#5f5f75",

    "last-move": "bg:#33332e",
    "last-move.light-piece": "fg:#a9a596",
    "last-move.dark-piece": "fg:#5f5f75",

    "pre-move": "bg:#36312b",
    "pre-move.light-piece": "fg:#a9a596",
    "pre-move.dark-piece": "fg:#5f5f75",

    "in-check": "bg:#3f2b30",
    "in-check.light-piece": "fg:#a9a596",
    "in-check.dark-piece": "fg:#5f5f75",
}
