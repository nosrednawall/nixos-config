{ config, lib, pkgs, ... }:

{
   home.packages = with pkgs; [
     dunst
   ];

   services.dunst.enable = true;
   xdg.configFile."dunst".source = ../config/dunst;
}
