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

  # Copia sua configuração local do Doom
  home.file.".local/bin/install-doom" = {
    source = ../scripts/install-doom;  # Pasta local com init.el, config.el, packages.el
    recursive = true;
  };



  home.activation.installDoom = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.config/emacs" ]; then
      echo "Instalando Doom Emacs..."
      ~/.local/bin/install-doom
    fi
  '';
}
