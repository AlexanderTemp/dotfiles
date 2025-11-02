
if status is-interactive # Starship Prompt
	
    starship init fish | source

    # Aliases
    alias g="git"
    alias ga="git add ."
    alias d="docker"
    alias x="exit"
    
    alias t="tmux"
    alias muxi="tmuxifier"
    alias muxi-load="tmuxifier load-session "

    alias ii="npm install"
    alias dev="npm run dev"

    alias v="vim"

    # ripgrep
    alias rgf="rg --files | rg" 
    alias fd="fdfind"
    alias qw="ls -alt | head -n 10"

    # docker 
    alias dps="~/docker-ps-visual.sh"
    alias dpr="~/docker-ps-visual.sh -r"
    alias dpa="~/docker-ps-visual.sh -a"
    alias dpar="~/docker-ps-visual.sh -a -r"
   

    # Cargar NVM
    nvm use v20
    
    # path nvim 
    alias nv="nvim"

end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# tmuxifier
set -gx PATH "$HOME/.tmuxifier/bin" $PATH 

# laravel
set -gx PATH "$HOME/.config/herd-lite/bin" $PATH

# neovim
set -gx PATH "$HOME/neovim/bin" $PATH

