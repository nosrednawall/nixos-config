{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
    dex  # Para gerenciar .desktop
  ];

}
