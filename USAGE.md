# Uso

Flujos de trabajo de este setup que no son un simple atajo/alias (eso vive en `SHORTCUTS.md`).

## Índice

- [Sesiones de tmux con nombre](#sesiones-de-tmux-con-nombre)

## Sesiones de tmux con nombre

Sin tmuxifier, sin auto-guardado: armás la sesión a mano (paneles, ventanas, programas corriendo) y la guardás con nombre cuando queda como querés. Los snapshots viven en `~/.tmux/resurrect/named/*.txt` (local, no se commitean).

| Acción | Atajo |
|---|---|
| Guardar sesión actual con nombre | `prefix S` |
| Cargar un layout guardado (popup fzf) | `prefix L` |
| Guardar snapshot sin nombre | `prefix Ctrl-s` |
| Restaurar snapshot sin nombre | `prefix Ctrl-r` |

Flujo típico: abrís tmux, armás paneles/ventanas, `prefix S` → nombre (ej. "backend"). La próxima vez: `prefix L` → elegís "backend".
