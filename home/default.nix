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
  ];

  home.username = "anderson";
  home.homeDirectory = "/home/anderson";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
