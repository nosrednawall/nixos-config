{ config, pkgs, lib, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      jetbrains-mono
      liberation_ttf
      nerd-fonts-iosevka-term
      nerd-fonts-symbols-only
    ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono" ];
    };
  };
}
