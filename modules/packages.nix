{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core CLI
    git
    neovim
    wget
    curl
    htop
    unzip
    ripgrep
    fd
    tree
    man-pages
    fastfetch
    zoxide
    fzf
    eza
    bat
    lazygit
    delta
    btop


    # GUI
    firefox
    mpv
    feh
    xclip
    dunst
    picom
    arandr
    pavucontrol
    networkmanagerapplet
    pcmanfm
    thunar
    flameshot
    conky
    copyq
    rofi
    geany
    lxappearance
    calibre
    alacritty
    xournalpp
    brave
  ];
}
