#
# Simple, clean Zsh config with:
# - Minimal prompt: just a colored ">" and a space
# - Built-in command prediction (no external plugins)
# - Nice completion and history behavior
#

##### Basics #####

export EDITOR="nano"

setopt NO_BEEP
setopt AUTO_MENU          # automatically show completion menu when pressing Tab repeatedly
setopt AUTO_LIST          # show list of choices on ambiguous completion
setopt COMPLETE_IN_WORD

setopt INTERACTIVE_COMMENTS
# Quality-of-life options
setopt AUTO_CD            # "cd" into a directory by just typing its name
setopt AUTO_PUSHD         # maintain a directory stack when changing dirs
setopt PUSHD_IGNORE_DUPS  # don't store the same directory multiple times
setopt EXTENDED_GLOB      # more powerful filename matching (e.g. ^pattern)


##### History #####

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY # write each command to history immediately
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS


##### Completion system #####

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'


##### Colors #####

autoload -Uz colors
colors


##### Prompt (only "> " and nothing else) #####

setopt PROMPT_SUBST

# Just a colored "❯" and a space, no directory/user/host
PROMPT='%F{#8B4100}❯%f '


##### Command prediction (built-in zsh/predict) #####

if zmodload -i zsh/predict 2>/dev/null; then
  autoload -Uz predict-on predict-off

  # Turn prediction on by default
  predict-on

  # Optional: toggle prediction with Ctrl-P if you ever want to
  bindkey '^P' predict-toggle
fi


##### Useful keybindings #####

bindkey -e  # Emacs-style keybindings

# Up/Down search history by the prefix you've typed
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

##### Aliases & helpers #####

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
mkcd() { mkdir -p "$1" && cd "$1"; }

# Clearing
alias c='clear'
alias clr='clear'

# Git shortcuts
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gp='git push'
alias ginit='git init'

# Open remote repo in browser at current branch
alias gop='open "$(git remote get-url origin | sed -e "s|git@\(.*\):\(.*\)\.git|https://\1/\2|" -e "s|\.git$||")/tree/$(git rev-parse --abbrev-ref HEAD)"'

# ESP-IDF
alias get_idf='. /Users/apple/esp/esp-idf/export.sh'


##### Colored ls / lsd #####

# Keep macOS ls colors available as a fallback
export CLICOLOR=1
export LSCOLORS=ExFxBxDxExbxbxabababab
export LS_COLORS='no=38;2;192;202;245:fi=38;2;192;202;245:di=38;2;122;162;247:ln=38;2;187;154;247:pi=38;2;125;207;255:so=38;2;125;207;255:bd=38;2;224;175;104:cd=38;2;224;175;104:or=38;2;247;118;142:mi=38;2;247;118;142:ex=38;2;158;206;106:tw=38;2;158;206;106:ow=38;2;158;206;106:st=38;2;158;206;106:'

# Prefer lsd (modern ls) if installed, otherwise fall back to classic ls.
unalias ls 2>/dev/null
unfunction ls 2>/dev/null

if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd'
  alias ll='lsd -alF'
  alias la='lsd -a'
else
  alias ls='ls -FGx'
  alias ll='ls -FGhl'
  alias la='ls -FGhla'
fi
# rbenv (Homebrew)
if command -v rbenv >/dev/null 2>&1; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - zsh)"
fi

. "$HOME/.local/bin/env"
export PATH="$HOME/.cargo/bin:$PATH"
export SSL_CERT_FILE="$(brew --prefix)/etc/ca-certificates/cert.pem"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/apple/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# opencode
export PATH=/Users/apple/.opencode/bin:$PATH
