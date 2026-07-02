{ config, pkgs, lib, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      jetbrains-mono
      liberation_ttf
    ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono" ];
    };
  };
}
