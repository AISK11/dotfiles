## AUTHOR:      AISK11
## LOCATION:    ~/.zshrc (0644)
## DESCRIPTION: ZSH shell configuration file.
## SOURCES:     https://www.zsh.org/
## - ARCH:      extra/zsh [community/zsh-autosuggestions]
##              [community/zsh-syntax-highlighting] [community/zsh-completions]

## Shell options (view set and unset options via $(setopt) or $(unsetopt)).
setopt vi
setopt nobeep
setopt bsdecho
setopt shwordsplit
setopt interactivecomments
setopt nohashcmds
setopt autocd
setopt cdsilent
setopt histexpiredupsfirst
setopt histfcntllock
setopt histfindnodups
setopt histignorealldups
setopt histignorespace
setopt histreduceblanks
setopt histsavenodups
setopt histverify
setopt sharehistory
setopt promptsubst
setopt nonomatch
setopt noautolist
setopt noautoparamkeys

## Shell autocompletion.
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

## Keyboard shortcuts.
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
[ -n "${key[Home]}"      ] && bindkey -M vicmd -- "${key[Home]}" vi-beginning-of-line
[ -n "${key[End]}"       ] && bindkey -M vicmd -- "${key[End]}"  vi-end-of-line
[ -n "${key[Home]}"      ] && bindkey -- "${key[Home]}"      beginning-of-line
[ -n "${key[End]}"       ] && bindkey -- "${key[End]}"       end-of-line
[ -n "${key[Backspace]}" ] && bindkey -- "${key[Backspace]}" backward-delete-char
[ -n "${key[Delete]}"    ] && bindkey -- "${key[Delete]}"    delete-char
[ -n "${key[Insert]}"    ] && bindkey -- "${key[Insert]}"    overwrite-mode
[ -n "${key[Up]}"        ] && bindkey -- "${key[Up]}"        up-line-or-history
[ -n "${key[Down]}"      ] && bindkey -- "${key[Down]}"      down-line-or-history
[ -n "${key[Left]}"      ] && bindkey -- "${key[Left]}"      backward-char
[ -n "${key[Right]}"     ] && bindkey -- "${key[Right]}"     forward-char
[ -n "${key[Shift-Tab]}" ] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

## Shell variables.
export PATH=''
[ -d "${HOME}/bin" ]        && PATH="${PATH}:${HOME}/bin"
[ -d "${HOME}/.local/bin" ] && PATH="${PATH}:${HOME}/.local/bin"
[ ! -L "/sbin" ]            && PATH="${PATH}:/sbin"
[ ! -L "/bin" ]             && PATH="${PATH}:/bin"
[ ! -L "/usr/sbin" ]        && PATH="${PATH}:/usr/sbin"
[ ! -L "/usr/bin" ]         && PATH="${PATH}:/usr/bin"
[ ! -L "/usr/local/sbin" ]  && PATH="${PATH}:/usr/local/sbin"
[ ! -L "/usr/local/bin" ]   && PATH="${PATH}:/usr/local/bin"
PATH="${PATH#:}"
export HISTSIZE='5000'
export SAVEHIST="${HISTSIZE}"
export HISTFILE="${HOME}/.zsh_history"
export PS1='%B%(!.%F{red}.%F{green})%n%F{yellow}@%(!.%F{red}.%F{green})%m %F{blue}%~%F{yellow}${BRANCH} %(?.%F{green}.%F{red})%(!.#.$) %f%b'
export PS2='> '
export PS4='+ '
export PROMPT_EOL_MARK='%B%S%#%s%b'
export KEYTIMEOUT='40'
export LANG='C.UTF-8'
export LC_CTYPE="C.UTF-8"
export LC_NUMERIC="C.UTF-8"
export LC_TIME="C.UTF-8"
export LC_COLLATE="C.UTF-8"
export LC_MONETARY="C.UTF-8"
export LC_MESSAGES="C.UTF-8"
export LC_PAPER="C.UTF-8"
export LC_NAME="C.UTF-8"
export LC_ADDRESS="C.UTF-8"
export LC_TELEPHONE="C.UTF-8"
export LC_MEASUREMENT="C.UTF-8"
export LC_IDENTIFICATION="C.UTF-8"

## Program variables.
export COLOR_MODE='auto'
if [ -n "$(command -vp nvim)" ]; then
    export VISUAL='nvim'
elif [ -n "$(command -vp vim)" ]; then
    export VISUAL='vim'
elif [ -n "$(command -vp nvi)" ]; then
    export VISUAL='nvi'
elif [ -n "$(command -vp vi)" ]; then
    export VISUAL='vi'
fi
export EDITOR="${VISUAL}"
[ -n "$(command -vp less)" ] && export PAGER='less'
export LESS='-R --use-color -Ddr$Dub$DSky$DPkb$ -i --follow-name --file-size -Ps[File\: "?f%f:STDIN." | Lines\: %lt-%lb/%L (?e100:%Pb.\%)]$'
export LESSHISTFILE='/dev/null'
export LESSHISTSIZE='0'
export MANPAGER="${PAGER}"
export MANLESS='[Manual\: \$MAN_PN\ | Lines\: %lt-%lb/%L (?e100:%Pb.\%)]$'

## Shell functions.
precmd() {
    hash -r
    BRANCH="$(git branch 2> /dev/null | grep -F '*' | cut -d ' ' -f 2)"
    [ ! -z "${BRANCH}" ] && BRANCH=" (${BRANCH})"
}
zle-keymap-select () {
    if [ "${KEYMAP}" == 'main' ] || [ "${KEYMAP}" == 'viins' ]; then
        echo -ne '\e[5 q' ## Blinking bar.
    else
        echo -ne '\e[1 q' ## Blinking block.
    fi
    zle reset-prompt
}
zle -N zle-keymap-select
function command_not_found_handler {
    local ANSI_BOLD="\033[1m"
    local ANSI_BLACK="\e[30m"
    local ANSI_RED="\e[31m"
    local ANSI_GREEN="\e[32m"
    local ANSI_YELLOW="\e[33m"
    local ANSI_BLUE="\e[34m"
    local ANSI_MAGENTA="\e[35m"
    local ANSI_CYAN="\e[36m"
    local ANSI_WHITE="\e[37m"
    local ANSI_RESET="\e[0m"
    ## Arch-based (requires $(pacman -Fy)).
    if [ -n "$(command -vp pacman)" ]; then
        echo -e "${ANSI_RED}Command '${0}' not found!${ANSI_RESET}"
        ENTRIES=(
            ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/${1}" 2> /dev/null)"}
        )
        if (( ${#ENTRIES[@]} )); then
        echo -e "${ANSI_YELLOW}'${0}' can be found in the following packages:${ANSI_RESET}"
        local PKG
        for ENTRY in "${ENTRIES[@]}"
        do
            local FIELDS=(
                ${(0)ENTRY}
            )
            if [[ "${PKG}" != "${FIELDS[2]}" ]]
            then
                echo -e "${ANSI_BOLD}${ANSI_MAGENTA}${FIELDS[1]}/${ANSI_WHITE}${FIELDS[2]} ${ANSI_GREEN}${FIELDS[3]}${ANSI_RESET}"
            fi
            printf '    /%s\n' "${FIELDS[4]}"
            PKG="${FIELDS[2]}"
        done
        return 1
    fi
    ## Other.
    else
        echo -e "${ANSI_RED}Command '${0}' not found!${ANSI_RESET}"
        return 127
    fi
}

## Custom functions.
getshell() {
    SHELLFILE="$(ps -o cmd -h -p ${$} | cut -d " " -f 1)"
    [ "${SHELLFILE#-}" != "${SHELLFILE}" ] && ISLOGIN='-' || ISLOGIN=''
    echo "${ISLOGIN}$(basename $(readlink -f "${SHELLFILE#-}"))"
}

## Aliases.
unalias -a
alias history='history 0'
alias kill='kill -9'
alias killall='killall -9'
alias pstree='pstree -C age -h'
alias dmesg='dmesg --color=${COLOR_MODE}'
alias ls='ls --color=${COLOR_MODE} -F --group-directories-first'
alias tree='tree -C'
alias mkdir='mkdir -p'
alias rsync='rsync -av'
alias nl='nl -s " "'
alias cat='cat -v'
alias grep='grep --color=${COLOR_MODE}'
alias egrep='grep -E --color=${COLOR_MODE}'
alias fgrep='grep -F --color=${COLOR_MODE}'
alias diff='diff --color=${COLOR_MODE} -s'
alias date='date "+%Y-%m-%d %H:%M:%S %Z"'
alias ip='ip --color=${COLOR_MODE}'
alias mtr='mtr -t'
alias mp3gain='mp3gain -r -k'

## Replacement aliases.
if [ -n "$(command -vp nvim)" ]; then
    alias vim='nvim'
    alias nvi='nvim'
    alias vi='nvim'
elif [ -n "$(command -vp vim)" ]; then
    alias nvim='vim'
    alias nvi='vim'
    alias vi='vim'
elif [ -n "$(command -vp nvi)" ]; then
    alias nvim='nvi'
    alias vim='nvi'
    alias vi='nvi'
elif [ -n "$(command -vp vi)" ]; then
    alias nvim='vi'
    alias vim='vi'
    alias nvi='vi'
fi
if [ -z "$(command -vp xxd)" ]; then
    alias xxd='hexdump -C'
fi
if [ -n "$(command -vp lsd)" ]; then
    alias ls="$(command -v lsd)"
    alias tree='lsd --tree'
fi

## Custom aliases.
alias idate='\date "+%Y-%m-%dT%H:%M:%S%z"'
alias udate='\date -u "+%Y-%m-%dT%H:%M:%S%z"'
alias pname='ps -o cmd -h -p'
alias path='realpath -s'
alias linkpath='readlink -f'
alias cpf='cp -rTd --'
alias ipa='ip --color=${COLOR_MODE} -br a'
alias nvrun='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'

## Extensions.
## Requires 'zsh-autosuggestions' (https://github.com/zsh-users/zsh-autosuggestions).
if [ -f '/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' ]; then
    . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f '/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh' ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
## Requries 'zsh-syntax-highlighting' (https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md).
if [ -f '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]; then
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f '/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]; then
    . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[function]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='none'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=11'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=11'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=red'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=red'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue'
ZSH_HIGHLIGHT_STYLES[path]='fg=white,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=blue,underline'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold'
#ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=red'
#ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='none'
#ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='none'
#ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='none'
#ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='none'
#ZSH_HIGHLIGHT_STYLES[assign]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
#ZSH_HIGHLIGHT_STYLES[named-fd]='fg=yellow'
#ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[rc-quote]='none'
ZSH_HIGHLIGHT_STYLES[arg0]='none'
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red'
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=blue'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=green'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=yellow'

## TTY.
if [ "${TERM}" = 'linux' ]; then
    unicode_start
    [ -f '/usr/share/kbd/consolefonts/eurlatgr.psfu.gz' ] && setfont eurlatgr
    setleds -D +num
    setleds -D -caps
    setleds -D -scroll
    alias ls="$(command -v lsd) --icon never"
    alias tree="$(command -v lsd) --tree --icon never"
    local THEME='github-dark'
    #local THEME='1337'
    if [ "${THEME}" = 'github-dark' ]; then
        local THEME_COLOR_CLI_0='0d1117' ## Black
        local THEME_COLOR_CLI_1='fa7970' ## Red
        local THEME_COLOR_CLI_2='7ce38b' ## Green
        local THEME_COLOR_CLI_3='faa356' ## Yellow
        local THEME_COLOR_CLI_4='77bdfb' ## Blue
        local THEME_COLOR_CLI_5='cea5fb' ## Magenta
        local THEME_COLOR_CLI_6='a2d2fb' ## Cyan
        local THEME_COLOR_CLI_7='ecf2f8' ## White
        local THEME_COLOR_CLI_8='89929b' ## Bright Black
        local THEME_COLOR_CLI_9='fa7970' ## Bright Red
        local THEME_COLOR_CLI_A='7ce38b' ## Bright Green
        local THEME_COLOR_CLI_B='faa356' ## Bright Yellow
        local THEME_COLOR_CLI_C='77bdfb' ## Bright Blue
        local THEME_COLOR_CLI_D='cea5fb' ## Bright Magenta
        local THEME_COLOR_CLI_E='a2d2fb' ## Bright Cyan
        local THEME_COLOR_CLI_F='ffffff' ## Bright White
    elif [ "${THEME}" = '1337' ]; then
        local THEME_COLOR_CLI_0='000000' ## Black
        local THEME_COLOR_CLI_1='ff0000' ## Red
        local THEME_COLOR_CLI_2='00ff00' ## Green
        local THEME_COLOR_CLI_3='00ff00' ## Yellow
        local THEME_COLOR_CLI_4='00ff00' ## Blue
        local THEME_COLOR_CLI_5='00ff00' ## Magenta
        local THEME_COLOR_CLI_6='00ff00' ## Cyan
        local THEME_COLOR_CLI_7='00aa00' ## White
        local THEME_COLOR_CLI_8='00ff00' ## Bright Black
        local THEME_COLOR_CLI_9='aa0000' ## Bright Red
        local THEME_COLOR_CLI_A='00ff00' ## Bright Green
        local THEME_COLOR_CLI_B='00ff00' ## Bright Yellow
        local THEME_COLOR_CLI_C='00ff00' ## Bright Blue
        local THEME_COLOR_CLI_D='00ff00' ## Bright Magenta
        local THEME_COLOR_CLI_E='00ff00' ## Bright Cyan
        local THEME_COLOR_CLI_F='00ff00' ## Bright White
    fi
    if [ -n "${THEME}" ]; then
        echo -en "\033]P0${THEME_COLOR_CLI_0}" ## Black
        echo -en "\033]P1${THEME_COLOR_CLI_1}" ## Red
        echo -en "\033]P2${THEME_COLOR_CLI_2}" ## Green
        echo -en "\033]P3${THEME_COLOR_CLI_3}" ## Yellow
        echo -en "\033]P4${THEME_COLOR_CLI_4}" ## Blue
        echo -en "\033]P5${THEME_COLOR_CLI_5}" ## Magenta
        echo -en "\033]P6${THEME_COLOR_CLI_6}" ## Cyan
        echo -en "\033]P7${THEME_COLOR_CLI_7}" ## White
        echo -en "\033]P8${THEME_COLOR_CLI_8}" ## Bright Black
        echo -en "\033]P9${THEME_COLOR_CLI_9}" ## Bright Red
        echo -en "\033]PA${THEME_COLOR_CLI_A}" ## Bright Green
        echo -en "\033]PB${THEME_COLOR_CLI_B}" ## Bright Yellow
        echo -en "\033]PC${THEME_COLOR_CLI_C}" ## Bright Blue
        echo -en "\033]PD${THEME_COLOR_CLI_D}" ## Bright Magenta
        echo -en "\033]PE${THEME_COLOR_CLI_E}" ## Bright Cyan
        echo -en "\033]PF${THEME_COLOR_CLI_F}" ## Bright White
    fi
    unset THEME THEME_COLOR_CLI_0 THEME_COLOR_CLI_1 THEME_COLOR_CLI_2 \
    THEME_COLOR_CLI_3 THEME_COLOR_CLI_4 THEME_COLOR_CLI_5 THEME_COLOR_CLI_6 \
    THEME_COLOR_CLI_7 THEME_COLOR_CLI_8 THEME_COLOR_CLI_9 THEME_COLOR_CLI_A \
    THEME_COLOR_CLI_B THEME_COLOR_CLI_C THEME_COLOR_CLI_D THEME_COLOR_CLI_E \
    THEME_COLOR_CLI_F
fi

## General.
tabs 4
clear
