{ config, lib, pkgs, ... }:

{
  # Manter seu setup atual, mas adicionar mais recursividade
  home.file = {
    ".local/bin/dmenu" = {
      source = ../scripts/dmenu;
      recursive = true;
      executable = true;
    };
    ".local/bin/dwm" = {
      source = ../scripts/dwm;
      recursive = true;
      executable = true;
    };
    ".local/bin/dwmblocks" = {
      source = ../scripts/dwmblocks;
      recursive = true;
      executable = true;
    };
    ".local/bin/others" = {
      source = ../scripts/others;
      recursive = true;
      executable = true;
    };
    ".local/bin/themes" = {
      source = ../scripts/themes;
      recursive = true;
      executable = true;
    };
    ".local/bin/conky" = {
      source = ../scripts/conky;
      recursive = true;
      executable = true;
    };
    ".local/bin/potato-c" = {
      source = ../scripts/potato-c;
      recursive = true;
      executable = true;
    };
    ".local/bin/instalacao" = {
      source = ../scripts/instalacao;
      recursive = true;
      executable = true;
    };
    ".local/bin/wall-set" = {
      source = ../scripts/wall-set;
      executable = true;
    };
  };
}
