# display UTF-8 filenames (e.g. Chinese)
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

alias protonmail-bridge='PASSWORD_STORE_DIR=$HOME/.config/protonmail-pass protonmail-bridge'

alias lf=lfrun

export NEXTCLOUD_PHP_CONFIG=/etc/webapps/nextcloud/php.ini

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    PS4=$'%D{%M%S%.} %N:%i> '
    mkdir -p $HOME/tmp
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

export CONFORG_DIR=$HOME/.dot-config
export CONDA_DIR=$HOME/miniconda3
export CLI_UTILS_DIR=$HOME/cli-utils
export SCRIPTS_DIR=$HOME/.scripts

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

POWERLEVEL9K_COLOR_SCHEME='dark'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs anaconda virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)

POWERLEVEL9K_SHORTEN_DELIMITER=''
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

POWERLEVEL9K_OS_ICON_BACKGROUND='248'
POWERLEVEL9K_OS_ICON_FOREGROUND='237'

POWERLEVEL9K_DIR_ETC_BACKGROUND='166'
POWERLEVEL9K_DIR_ETC_FOREGROUND='237'
POWERLEVEL9K_DIR_HOME_BACKGROUND='72'
POWERLEVEL9K_DIR_HOME_FOREGROUND='237'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='132'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='237'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='66'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='237'

POWERLEVEL9K_ANACONDA_BACKGROUND="109"
POWERLEVEL9K_ANACONDA_FOREGROUND="237"

POWERLEVEL9K_VIRTUALENV_BACKGROUND="109"
POWERLEVEL9K_VIRTUALENV_FOREGROUND="237"

POWERLEVEL9K_VCS_CLEAN_BACKGROUND='106'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='237'

POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='214'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='237'

POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='167'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='237'

POWERLEVEL9K_STATUS_OK_FOREGROUND='237'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='124'
POWERLEVEL9K_STATUS_OK_BACKGROUND='248'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='248'

POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='237'
POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='166'

source $CONFORG_DIR/contrib/powerlevel10k/powerlevel10k.zsh-theme

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

case $- in
    *i*) ;;
    *) return;;
esac

bindkey -e

export GPG_TTY=$(tty)

source  /etc/profile

[[ ! -f ~/.bash_profile ]] || source $HOME/.bash_profile

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

if [ -f $CONFORG_DIR/contrib/bash-insulter/src/bash.command-not-found ]; then
    source $CONFORG_DIR/contrib/bash-insulter/src/bash.command-not-found
fi

if [ -f $CONDA_DIR/etc/profile.d/conda.sh ]; then
# . $CONDA_DIR/etc/profile.d/conda.sh  # commented out by conda initialize
fi

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab

export PATH=$HOME/.local/bin:$PATH
export PATH=$CLI_UTILS_DIR:$PATH
export PATH=$SCRIPTS_DIR:$PATH

export PATH=$HOME/.cargo/bin:$PATH 
export PATH=$HOME/.radicle/bin:$PATH 

export MANPAGER="sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu' \
    -c 'nnoremap i <nop>' \
    -c 'nnoremap <Space> <C-f>' \
    -c 'noremap q :quit<CR>' -\""

export EDITOR="nvim"
export VISUAL="nvim"

export _MENU_THEME=legacy

export TERM=screen-256color

export PIP_REQUIRE_VIRTUALENV=false

# autoload zkbd
# [[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd
# source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

SAVEHIST=3153600000            # limit of the saved history = 3600 * 24 * 365 * 100
HISTFILE=~/.zsh_history

setopt share_history           # share history between all sessions
setopt extended_history        # :start:elapsed;command format
setopt inc_append_history      # write to the history file immediately, not when the shell exits.

setopt hist_ignore_dups        # don't record repeated commands
setopt hist_ignore_all_dups    # when a new dup is recorded, delete the old one
setopt hist_reduce_blanks      # remove superfluous blanks

# For privacy and security
setopt hist_ignore_space       # don't record an entry starting with a space
setopt hist_verify             # don't execute immediately upon expansion

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

GIT_COMPLETION_ZSH=/usr/share/git/completion/git-completion.zsh
if [ -f $GIT_COMPLETION_ZSH ]; then
    zstyle ':completion:*:*:git:*' script $GIT_COMPLETION_ZSH
fi

fpath+=$CONFORG_DIR/contrib/conda-zsh-completion
compinit conda
zstyle ':completion::complete:*' use-cache 1

compctl -m npx

GITA_COMPLETION_ZSH=$CONFORG_DIR/contrib/gita/.gita-completion.zsh
if [ -f $GITA_COMPLETION_ZSH ]; then
    zstyle ':completion:*:*:git:*' script $GITA_COMPLETION_ZSH
fi

case `uname` in
    Darwin)
        # commands for OS X go here
        alias ls='gls --color=auto'
        alias dir='gdir --color=auto'
        alias vdir='gvdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
        alias ctags='/usr/local/bin/ctags'
        ;;
    Linux)
        # commands for Linux go here
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
        ;;
    FreeBSD)
        # commands for FreeBSD go here
        ;;
esac

alias ll='ls -alhF'
alias la='ls -a'
alias l='ls -F'

alias c='conda'
alias ca='conda activate'

alias icat='kitty +kitten icat'

alias vi='nvim'
alias vim='nvim'

alias emacs='SHELL=/bin/bash LC_CTYPE=zh_CN.UTF-8 emacs'
alias ec='emacsclient -n -c'

alias t='task'

alias tmux='tmux -u'

alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

alias gg='grep -rn'

autoload -U zcalc
function __calc_plugin {
    zcalc -e "$*"
}
aliases[calc]='noglob __calc_plugin'
# aliases[=]='noglob __calc_plugin'

alias kk='kitty -1'

LS_COLORS=$(<$CONFORG_DIR/contrib/dircolors-solarized/dircolors.256dark)

zstyle ':completion:*' list-colors "${(@s.:.)}LS_COLORS"

# export LSCOLORS="Gxfxcxdxbxegedabagacad"

export GPG_TTY=$(tty)

source /home/haohan/.local/share/fzf/shell/completion.zsh

source /home/haohan/.local/share/fzf/shell/key-bindings.zsh

for dump in $HOME/.zcompdump(N.mh+24); do
    # echo "Updating completion cache.."
    compinit
    compdump
done

compinit -C

if type "kitty" > /dev/null; then
    kitty + complete setup zsh | source /dev/stdin
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f /usr/share/nvm/init-nvm.sh ]; then
    source /usr/share/nvm/init-nvm.sh
fi

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/haohan/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/haohan/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/haohan/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/haohan/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

