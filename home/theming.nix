{ config, pkgs, lib, ... }:

let
  themeContent = ''
    #!/bin/bash
    THEME_GTK="Nordic-darker-v40"
    THEME_ICON="Zafiro-Nord-Black"
    THEME_MODE="Nord"
    COLOR_MODE="Dark"
    THEME_ICON_DUNST="/usr/share/icons/Papirus-Dark/"
    GTK_PREFER_DARK_MODE="1"
    EMACS_THEME="doom-nord"
    WALLPAPER_LIGHTDM="ign_unsplash15.png"
    COLOR_BACKGROUND="#2e3440"
    COLOR_BACKGROUND2="#3b4252"
    COLOR_TEXT="#d8dee9"
    COLOR_1="#ebcb8b"
    COLOR_2="#d08770"
    COLOR_3="#bf616a"
    COLOR_4="#b48ead"
    COLOR_5="#81a1c1"
    COLOR_6="#88c0d0"
    COLOR_7="#a3be8c"
    COLOR_8="#4c566a"
    COLOR_9="#f5e5bc"
    COLOR_10="#e5a28a"
    COLOR_11="#d97782"
    COLOR_12="#c9a5c7"
    COLOR_13="#a8c7e0"
    COLOR_14="#a0d5e0"
    COLOR_15="#c3d8b1"
    COLOR_16="#6d798c"
  '';

  themeScript = pkgs.writeShellScriptBin "ensure-theme" ''
    THEME_FILE="$HOME/.theme_selected"

    if [ ! -f "$THEME_FILE" ]; then
      cat > "$THEME_FILE" << 'EOF'
    ${themeContent}
    EOF
      chmod +x "$THEME_FILE"
      echo "Arquivo ~/.theme_selected criado"
    fi
  '';
in {
  # ... suas outras configurações ...

  home.packages = with pkgs; [
    pywal
    feh
    nsxiv
  ];


  home.file.".theme_selected" = {
    text = themeContent;
    executable = true;
    # force = false; # Não sobrescreve se existir
  };

  home.activation.ensureTheme = pkgs.lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.theme_selected" ]; then
      ${themeScript}/bin/ensure-theme
    fi
  '';


  # Pywal templates — wal generates themed configs from these
  xdg.configFile."wal/templates".source = ../config/wal/templates;

  # Install wall-set script
  home.file.".local/bin/wall-set" = {
    source = ../scripts/wall-set;
    executable = true;
  };


}
