{ config, lib, pkgs, ... }:

{
   home.packages = with pkgs; [
     dunst
   ];

   xdg.configFile."dunst".source = ../config/dunst;
   services.dunst.enable = true;
}
