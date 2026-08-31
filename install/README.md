# install/

Scripts de bootstrap para una instalación limpia. **No es un paquete de stow**
— nunca corras `stow install`, este directorio se ejecuta directo desde el
repo y no debe symlinkearse a `$HOME`.

- `install-arch.sh`: instala vía `pacman` (+ un puñado de instaladores curl)
  todo lo que necesitan estos dotfiles en Arch/CachyOS — único sistema
  soportado — **excepto nvim** (ese va por tarball a mano, ver `README.md`
  del repo).

## Prerequisito (no lo automatiza el script)

Si el repo es privado y clonás por SSH, necesitás la key ya agregada a tu
cuenta de Git *antes* de `git clone`. No hay forma de scriptear esto: el
script vive adentro del repo que todavía no existe en el disco en ese punto.
Ver la nota en el `README.md` de la raíz, sección Instalación.

## Si algo falla a mitad de camino

El script corre con `set -euo pipefail` + un trap en `ERR`: cualquier
comando que falle (paquete no encontrado, sin red, un `curl` que devuelve
404) corta la ejecución ahí mismo e imprime la línea y el comando exacto que
falló — no sigue en un estado a medias ni falla en silencio. Solucionás lo
puntual y volvés a correr `./install-arch.sh`: es idempotente (cada bloque
chequea `command -v` / `pacman -T` antes de instalar), así que no repite lo
que ya quedó instalado, solo retoma desde donde cortó.

Dos casos ya cubiertos así, a modo de referencia:
- Un `pacman -Syu` que trae kernel nuevo sin reiniciar: el script lo detecta
  (no hay módulos del kernel corriendo en disco) y corta con instrucciones
  de reiniciar, antes de que eso rompa docker/nftables más abajo.
- `claudebar` instalado pero `claude` sin loguear: esto **no** hace fallar el
  script — el binario se instala igual, y el error queda contenido en el
  propio módulo de waybar (ícono de advertencia), no en el bootstrap.

Ver `../HISTORY.md` para el detalle de qué se instaló manualmente en la
última instalación limpia y el registro de la migración desde Debian/Ubuntu.
