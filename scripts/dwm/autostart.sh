#!/usr/bin/env bash

# Função para verificar se um processo está rodando
is_running() {
    ps aux | grep -v grep | grep -q "$1"
}

# ============================================
# GERENCIADOR DE AUTOSTART (via .desktop)
# ============================================
# Executa todos os arquivos .desktop em ~/.config/autostart
# Usa o dex para gerenciar isso
#is_running "dex" || dex --autostart --environment xdg &

# ============================================
# PROGRAMAS ESPECÍFICOS (que não usam .desktop)
# ============================================

# Inicia o xautolock (não tem .desktop padrão)
is_running "xautolock" || xautolock -time 15 -locker ~/.local/bin/dwm/dwm-slock -detectsleep &

# Inicia o picom
is_running "picom" || picom -b

# Inicia o dwmblocks
is_running "dwmblocks" || dwmblocks &

# ============================================
# PROGRAMAS DESATIVADOS (exemplos)
# ============================================

# Inicia o copyq se não estiver rodando (agora gerenciado pelo .desktop)
# is_running "copyq" || copyq &

# Inicia o dunst se não estiver rodando
# is_running "dunst" || dunst -conf "$HOME/.config/dunst/themes/${THEME_MODE}_${COLOR_MODE}" &

# Inicia o daemon do emacs se não estiver rodando
# is_running "emacs" || emacs --daemon &

# Solaar (desativado)
# is_running "solaar" || /usr/bin/solaar -w hide &
