{ config, pkgs, lib, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./mpv.nix
    ./tmux.nix
    ./neovim.nix
    ./ohmyposh.nix
    ./theming.nix
    ./scripts.nix
    ./dunst.nix
    ./copyq.nix
    ./emacs.nix

  ];

  home.username = "anderson";
  home.homeDirectory = "/home/anderson";

  # Copia sua configuração local do Doom
  home.file.".config/rofi" = {
    source = ../config/rofi;  # Pasta local com init.el, config.el, packages.el
    recursive = true;
  };

  home.file.".config/flameshot" = {
    source = ../config/flameshot;  # Pasta local com init.el, config.el, packages.el
    recursive = true;
  };


  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
