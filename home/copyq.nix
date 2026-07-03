{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
  ];

  # Cria uma configuração limpa
  home.file.".config/copyq/copyq.conf".text = ''
    [General]
    autostart=false
    showTray=true
    saveOnExit=true
    maxClipboardItems=50
    shortcuts=meta+v
    theme=default
    language=pt_BR
    style=Default
  '';

  # Opcional: remove scripts antigos
  home.activation = {
    cleanupCopyq = ''
      if [ -d "$HOME/.config/copyq" ]; then
        # Remove scripts problemáticos
        rm -f "$HOME/.config/copyq/scripts"/* 2>/dev/null || true
      fi
    '';
  };
}
