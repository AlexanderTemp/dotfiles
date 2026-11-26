if status is-interactive
    starship init fish | source

    # brblack del tema se pierde sobre la terminal translúcida
    set -g fish_color_autosuggestion 9a98a8

    if type -q zoxide
        zoxide init fish --cmd cd | source
    end

    if type -q fzf
        fzf --fish | source
    end
end

set -Ux fish_user_paths \
    /opt/nvim/bin \
    $HOME/.bun/bin \
    $HOME/.dotnet \
    $HOME/.dotnet/tools \
    $HOME/.config/herd-lite/bin \
    $fish_user_paths

set -gx DOTNET_ROOT $HOME/.dotnet

set -gx BUN_INSTALL $HOME/.bun

set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

set -gx SDKMAN_DIR $HOME/.sdkman
set -gx JAVA_HOME $SDKMAN_DIR/candidates/java/current
fish_add_path -p $JAVA_HOME/bin
fish_add_path -p $SDKMAN_DIR/candidates/gradle/current/bin

fish_add_path $HOME/.local/bin

if type -q pyenv
    pyenv init - | source
end

if test -f ~/.adas-cli/.adas-cli-completion-fish
    source ~/.adas-cli/.adas-cli-completion-fish
end

fish_add_path $HOME/.opencode/bin
