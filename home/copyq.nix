{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
  ];

  home.file.".xprofile".text = ''
    # Garante o PATH do NixOS para o .xprofile
    export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:$PATH"

    # Inicia o CopyQ
    /run/current-system/sw/bin/copyq --start-server --disable-tray &
    '';
}
