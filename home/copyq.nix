{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
  ];




  home.file.".xprofile".text = ''
    # Garante o PATH do NixOS para o .xprofile
    export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"

    # Aguarda o servidor X iniciar
    sleep 2

    # Inicia o CopyQ usando o caminho do perfil do usuário
    ${pkgs.copyq}/bin/copyq --start-server --disable-tray &
  '';
}
