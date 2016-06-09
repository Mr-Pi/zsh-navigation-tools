#!/usr/bin/env zsh

#
# No plugin manager is needed to use this file. All that is needed is adding:
#   source {where-znt-is}/zsh-navigation-tools.plugin.zsh
#
# to ~/.zshrc.
#

# This gives immunity to functionargzero being unset
# _ will be set to last argument to source builtin
PLUGIN_UNDERSCORE="$_"
[ "$0" != "$PLUGIN_UNDERSCORE" ] && 0="$PLUGIN_UNDERSCORE"

REPO_DIR="${0%/*}"
CONFIG_DIR="$HOME/.config/znt"

#
# Update FPATH if:
# 1. Not loading with Zplugin
# 2. Not having fpath already updated (that would equal: using other plugin manager)
#

if [[ -z "$ZPLG_CUR_PLUGIN" && "${fpath[(r)$REPO_DIR]}" != $REPO_DIR ]]; then
    fpath+=( "$REPO_DIR" )
fi

#
# Copy configs
#

if ! test -d "$HOME/.config"; then
    mkdir "$HOME/.config"
fi

if ! test -d "$CONFIG_DIR"; then
    mkdir "$CONFIG_DIR"
fi

# 9 files
set n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf

# Check for random 2 files if they exist
# This will shift 0 - 7 elements
shift $(( RANDOM % 8 ))
if ! test -f "$CONFIG_DIR/$1" || ! test -f "$CONFIG_DIR/$2"; then
    # Something changed - examine every file
    set n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf
    for i; do
        if ! test -f "$CONFIG_DIR/$i"; then
            cp "$REPO_DIR/.config/znt/$i" "$CONFIG_DIR"
        fi
    done
fi

# Don't leave positional parameters being set
set --

#
# Load functions
#

autoload n-aliases n-cd n-env n-functions n-history n-kill n-list n-list-draw n-list-input n-options n-panelize n-help
autoload znt-usetty-wrapper znt-history-widget znt-cd-widget znt-kill-widget
alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history
alias nkill=n-kill noptions=n-options npanelize=n-panelize nhelp=n-help

zle -N znt-history-widget
bindkey '^R' znt-history-widget
setopt AUTO_PUSHD HIST_IGNORE_DUPS PUSHD_IGNORE_DUPS
zstyle ':completion::complete:n-kill::bits' matcher 'r:|=** l:|=*'

