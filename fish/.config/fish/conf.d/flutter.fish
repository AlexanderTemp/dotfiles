# Flutter y Android comparten el SDK usado por Android Studio.
set -gx FLUTTER_ROOT $HOME/.local/share/flutter
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_SDK_ROOT $ANDROID_HOME
set -gx CHROME_EXECUTABLE /usr/bin/chromium
fish_add_path $FLUTTER_ROOT/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/cmdline-tools/latest/bin
