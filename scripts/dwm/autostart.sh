#!/usr/bin/env bash

# Função para verificar se um processo está rodando
is_running() {
    ps aux | grep -v grep | grep -q "$1"
}


# Inicia o xautolock com as configurações personalizadas se não estiver rodando
is_running "xautolock" || xautolock -time 15 -locker ~/.local/bin/dwm/dwm-slock -detectsleep &

# Inicia o picom em modo background
is_running "picom" || picom -b

copyq --start-server --config-dir ~/.config/copyq &

# Inicia o dunst se não estiver rodando
#is_running "dunst" || dunst -conf "$HOME/.config/dunst/themes/${THEME_MODE}_${COLOR_MODE}" &
#is_running "dunst" || dunst -conf "$HOME/.config/dunst/dunstrc" &

# Inicia o copyq se não estiver rodando
# is_running "copyq" || copyq &

# Inicia o daemon do emacs se não estiver rodando
#is_running "emacs" || emacs --daemon &

#is_running "solaar" || /usr/bin/solaar -w hide &
#TECLADO_USA_CONECTADO=$(solaar show 521B6154 | grep "unknown (device is offline)" -ic)
#setxkbmap -model pc105 -layout br -variant abnt2

is_running "dwmblocks" || dwmblocks &
