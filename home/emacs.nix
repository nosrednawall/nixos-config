{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    emacs
    git
    ripgrep
    fd
  ];

  # Copia sua configuração local do Doom
  home.file.".config/doom" = {
    source = ../config/doom;  # Pasta local com init.el, config.el, packages.el
    recursive = true;
  };

  # Script para instalar o Doom
  home.file.".local/bin/install-doom" = {
    text = ''
      #!/usr/bin/env bash
      if [ ! -d "$HOME/.config/emacs" ]; then
        git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
        ~/.config/emacs/bin/doom install
      fi
    '';
    executable = true;
  };

  home.activation.installDoom = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.config/emacs" ]; then
      echo "Instalando Doom Emacs..."
      ~/.local/bin/install-doom
    fi
  '';
}
