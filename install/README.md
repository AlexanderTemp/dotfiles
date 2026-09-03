# install/

Scripts de bootstrap para una instalación limpia. **No es un paquete de stow**
— nunca corras `stow install`, este directorio se ejecuta directo desde el
repo y no debe symlinkearse a `$HOME`.

- `install-arch.sh`: instala vía `pacman` (+ un puñado de instaladores curl)
  todo lo que necesitan estos dotfiles en Arch/CachyOS — único sistema
  soportado — **excepto nvim** (ese va por tarball a mano, ver `README.md`
  del repo).

Prerequisito de SSH: ver `README.md` de la raíz, sección Instalación.

Si algo falla, el script corta ahí mismo (`set -euo pipefail` + trap en
`ERR`) con la línea exacta — es idempotente, así que solo hace falta
resolver y volver a correrlo.

Ver `../HISTORY.md` para el detalle de qué se instaló manualmente en la
última instalación limpia y el registro de la migración desde Debian/Ubuntu.
