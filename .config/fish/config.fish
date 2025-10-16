
if status is-interactive # Starship Prompt
	
    starship init fish | source

    # Aliases
    alias g="git"
    alias ga="git add ."
    alias d="docker"
    alias x="exit"
    
    alias t="tmux"
    alias ii="npm install"
    alias dev="npm run dev"

    alias v="vim"

    alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

    # ripgrep
    alias rgf="rg --files | rg" 
    alias fd="fdfind"
    alias qw="ls -alt | head -n 10"

    # docker 
    alias dps="~/docker-ps-visual.sh"
    alias dpa="~/docker-ps-visual.sh -a"
    alias dpar="~/docker-ps-visual.sh -r"
   

    # Cargar NVM
    nvm use v20
    
    # path nvim 
    alias nv="nvim"
    

    function fzf-lovely
      set preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file ||
      (batcat --style=numbers --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -500'
      if test "$argv[1]" = "h"
    	fzf -m --reverse --preview-window down:20 --preview "$preview"
      else
    	fzf -m --preview "$preview"
      end
    end
    set -gx PATH "/home/alexander/.config/herd-lite/bin" $PATH

end


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
