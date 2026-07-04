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

}
