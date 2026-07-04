{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
  ];

  services.copyq.enable = true;
}
