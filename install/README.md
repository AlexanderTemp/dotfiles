# install/

Scripts de bootstrap para una instalación limpia. **No es un paquete de stow**
— nunca corras `stow install`, este directorio se ejecuta directo desde el
repo y no debe symlinkearse a `$HOME`.

- `install-arch.sh`: instala vía `pacman` (+ un puñado de instaladores curl)
  todo lo que necesitan estos dotfiles en Arch/CachyOS — único sistema
  soportado. También instala Bookokrat mediante Cargo y cli-chess mediante
  `uv tool`. nvim, Flutter/Android Studio y adas-cli tienen pasos manuales.

Prerequisito de SSH: ver `README.md` de la raíz, sección Instalación.

Si algo falla, el script corta ahí mismo (`set -euo pipefail` + trap en
`ERR`) con la línea exacta — es idempotente, así que solo hace falta
resolver y volver a correrlo.

## Lectura y ajedrez

El bootstrap instala `bookokrat` con `cargo install bookokrat --locked` y sus dependencias nativas para PDF/DJVU. Después de aplicar `stow -R fish`, basta con:

```fish
zen
zen "ruta/mi libro.epub"
zen "ruta/mi libro.epub" --zen-mode
cli-chess
```

`zen` es una función de Fish que pasa los argumentos al lector; no cambia las preferencias de Bookokrat. Para gráficos PDF/DJVU usa Kitty u otra terminal compatible. El historial de lectura, libros y anotaciones permanecen como datos locales.

`cli-chess` se instala para el usuario, sin `sudo pip` ni `--break-system-packages`. Mantenimiento:

```bash
uv tool upgrade cli-chess
uv tool uninstall cli-chess
```

El tablero usa un tema discreto (casillas casi del color del fondo, piezas apagadas): los colores están en el paquete stow `cli-chess` (`~/.config/cli-chess/custom_style.py`, sobrevive a `uv tool upgrade`) y `cli-chess-tema` (paquete `scripts`) ajusta en `config.ini` las coordenadas, el material y el color de 24 bits.

El acceso a Lichess es opcional y se configura dentro del entorno local del usuario, sin guardar tokens en dotfiles.

## Flutter y Android Studio

Estado de referencia del equipo: Flutter 3.47.7 / Dart 3.13.5, Android Studio en `/opt/android-studio`, SDK Android en `~/Android/Sdk`. Los plugins del IDE son Flutter 97.0.0 y Dart 510.0.0. Son las versiones verificadas, no versiones que debas congelar en una instalación futura.

El archivo `fish/.config/fish/conf.d/flutter.fish` conserva:

- `FLUTTER_ROOT=$HOME/.local/share/flutter` y su `bin` en el PATH.
- `ANDROID_HOME` y `ANDROID_SDK_ROOT` apuntando a `~/Android/Sdk`.
- `platform-tools` y `cmdline-tools/latest/bin` en el PATH.
- `CHROME_EXECUTABLE=/usr/bin/chromium` para Flutter web.

En una máquina nueva, después del bootstrap:

1. Instala Flutter estable, por ejemplo con Git (solo si esa carpeta todavía no existe):

   ```bash
   mkdir -p "$HOME/.local/share"
   git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$HOME/.local/share/flutter"
   ```

2. Instala Android Studio desde su distribución oficial en `/opt/android-studio` y los plugins **Flutter** y **Dart** desde el IDE. Elige `~/.local/share/flutter` como Flutter SDK, sin añadir `/bin`.
3. En SDK Manager instala Android SDK Platform, Build-Tools, Platform-Tools y **Android SDK Command-line Tools (latest)** en `~/Android/Sdk`. Añade Emulator y una imagen si vas a usar un dispositivo virtual.
4. Aplica `stow -R fish`, abre una terminal nueva y enlaza Flutter con el SDK y el IDE:

   ```fish
   flutter config --android-studio-dir /opt/android-studio --android-sdk "$HOME/Android/Sdk"
   flutter config --jdk-dir /ruta/a/un/jdk-compatible
   flutter doctor --android-licenses
   flutter doctor -v
   flutter devices
   ```

   En este equipo se usa `~/.jdks/jbr-21.0.11`, ya instalado: JDK 21 permite trabajar también con proyectos Gradle anteriores al JDK 25 del Android Studio actual. La ruta y la versión deben existir y ser compatibles con el Gradle del proyecto; el bootstrap no instala ese JDK.

El instalador sí añade las dependencias de escritorio/web (`clang`, `cmake`, `ninja`, `gtk3`, `pkgconf`, Chromium). Aquí CMake y Ninja ya estaban instalados con `uv tool`; en una instalación limpia se usan los paquetes de Arch.

Las preferencias personales del IDE, SDKs, emuladores, claves de firma y credenciales no se copian al repositorio. Verificación actual: `flutter doctor` sin incidencias y base Flutter compilada para Linux. Para un Android físico hay que activar depuración USB y autorizar el ordenador en el teléfono.

## Herramientas detectadas en el historial

Se revisaron nombres de comandos y frecuencia de uso, sin copiar el historial ni sus argumentos al repositorio:

| Uso | Cómo se restaura |
|---|---|
| `netstat` | paquete `net-tools` en el bootstrap |
| `lsof` | paquete `lsof` en el bootstrap |
| `qpdf` | paquete `qpdf` en el bootstrap |
| `trivy` | paquete `trivy` en el bootstrap |
| `ncdu` | paquete `ncdu` en el bootstrap (uso de disco interactivo) |
| `ufw` | paquete `ufw`; reglas y activación manuales por equipo |
| `adas-cli` | binario personal en `~/.local/bin/adas-cli`; reinstalar desde su distribución original y repetir su configuración/login |

`adas-cli` aparece con frecuencia, pero no pertenece a un paquete de pacman y no se identificó un instalador de origen en los dotfiles. Su autocompletado ya se carga condicionalmente desde `~/.adas-cli/.adas-cli-completion-fish`. No copies `~/.adas-cli`: contiene credenciales y estado del servicio.

La calculadora ya estaba cubierta: `rofi` + `rofi-calc`, script `calc-menu`, tema generado por Matugen y atajo `$mod+c` en sway.
