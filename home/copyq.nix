{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    copyq
    dex  # Para gerenciar .desktop
  ];

  # ============================================
  # ARQUIVOS .DESKTOP PARA AUTOSTART
  # ============================================

  # CopyQ
  home.file.".config/autostart/copyq.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=CopyQ
    Comment=Clipboard Manager
    Exec=${pkgs.copyq}/bin/copyq --start-server --disable-tray
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
  '';
}
