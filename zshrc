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

##### Optional plugins #####

for plugin_file in \
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
do
  if [ -f "$plugin_file" ]; then
    source "$plugin_file"
    break
  fi
done

for plugin_file in \
  /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh \
  /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
do
  if [ -f "$plugin_file" ]; then
    source "$plugin_file"
    break
  fi
done


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
if typeset -f history-substring-search-up >/dev/null 2>&1; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
else
  bindkey '^[[A' history-beginning-search-backward
  bindkey '^[[B' history-beginning-search-forward
fi

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
if command -v open >/dev/null 2>&1; then
  alias gop='open "$(git remote get-url origin | sed -e "s|git@\(.*\):\(.*\)\.git|https://\1/\2|" -e "s|\.git$||")/tree/$(git rev-parse --abbrev-ref HEAD)"'
elif command -v xdg-open >/dev/null 2>&1; then
  alias gop='xdg-open "$(git remote get-url origin | sed -e "s|git@\(.*\):\(.*\)\.git|https://\1/\2|" -e "s|\.git$||")/tree/$(git rev-parse --abbrev-ref HEAD)" >/dev/null 2>&1'
fi

# ESP-IDF
if [ -f "$HOME/esp/esp-idf/export.sh" ]; then
  alias get_idf='. "$HOME/esp/esp-idf/export.sh"'
fi

# Vivado
alias vivado-env='[ -n "${VIVADO_ROOT:-}" ] && [ -f "$VIVADO_ROOT/settings64.sh" ] && . "$VIVADO_ROOT/settings64.sh"'

# Always open VS Code in the next Hyprland workspace.
code() {
  if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] && command -v hyprctl >/dev/null 2>&1; then
    local current_ws target_ws

    if command -v jq >/dev/null 2>&1; then
      current_ws="$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.id // empty' 2>/dev/null)"
      if [[ "$current_ws" == <-> ]] && (( current_ws > 0 )); then
        target_ws=$((current_ws + 1))
      fi
    fi

    if [[ "$target_ws" == <-> ]] && (( target_ws > 0 )); then
      hyprctl dispatch workspace "$target_ws" >/dev/null 2>&1 || true
    else
      hyprctl dispatch workspace r+1 >/dev/null 2>&1 || true
    fi
  fi
  command code --new-window "$@"
}


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

if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

export PATH="$HOME/.cargo/bin:$PATH"

if command -v brew >/dev/null 2>&1; then
  export SSL_CERT_FILE="$(brew --prefix)/etc/ca-certificates/cert.pem"
fi

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=("$HOME/.juliaup/bin" $path)
export PATH

# <<< juliaup initialize <<<

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
alias btop="btop --force-utf"
if command -v ruby >/dev/null 2>&1; then
  export PATH="$(ruby -r rubygems -e 'print Gem.user_dir')/bin:$PATH"
else
  print -u2 "ruby is not installed; install ruby to enable gem bin PATH setup"
fi
alias get_idf='. /home/lazybanana/esp/esp-idf/export.sh'
