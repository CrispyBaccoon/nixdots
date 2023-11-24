#!/usr/bin/env bash

set -e

# -- variables --

# DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
# WALLCTL_DIR="$DATA_DIR/wallctl"
#
# mkdir -p "$WALLCTL_DIR"
#
# BIN_FILE="$WALLCTL_DIR/.wallpaperset"
# ENV_FILE="$WALLCTL_DIR/.wallpaperenv"

# -- utils --

msg() {
    printf "\033[32;1m%s\033[m %s\n" "$PROMPT" "$*"
}

warn() {
    >&2 printf "\033[33;1m%s \033[mwarning: %s\n" "$PROMPT" "$*"
}

die() {
    >&2 printf "\033[31;1m%s \033[merror: %s\n" "$PROMPT" "$*"
    exit 1
}

confirm() {
    >&2 printf "\033[33;1m%s \033[mconfirm? %s" "$PROMPT" "$CONFIRM_PROMPT"
    read -r ans
    if [ "$ans" != y ] ; then
        >&2 printf '%s\n' 'Exiting.'
        exit
    fi
}

# -- usage --

usage() {
>&2 cat <<"EOF"
   [system]  -  rebuild system
     [home]  -  rebuild home
EOF
exit 1
}

# -- main --

main() {
  [ "$1" ] || usage

  flag=${1#-}
  shift

  case $flag in
        system) rebuild_system $@ ;;
        home) rebuild_home $@ ;;
        *) die "command does not exist" ;;
  esac
}

rebuild_system() {
  sudo nixos-rebuild switch --flake .#$(hostname) $@ && notify-send "succesfully rebuild system" || notify-send -u critical "error while rebuilding system"
}
rebuild_home() {
  home-manager --flake .#$(whoami) switch $@ && notify-send "succesfully rebuild home" || notify-send -u critical "error while rebuilding home"
}

main $@
