{ config, pkgs, lib, ... }:

let
  myDwm = pkgs.dwm.overrideAttrs (old: {
    src = ../suckless/dwm;
    buildInputs = (old.buildInputs or []) ++ [
      pkgs.xorg.libX11
      pkgs.xorg.libXinerama
      pkgs.xorg.libXft
      pkgs.xorg.libXrender
      pkgs.xorg.libX11-xcb
      pkgs.xorg.libxcb
      pkgs.xorg.libxcb-res
      pkgs.fontconfig
      pkgs.xorg.libXext
      pkgs.xorg.libXpm
      pkgs.imlib2
    ];

    # Isto vai criar um wrapper que aponta para as bibliotecas corretas
    postInstall = ''
      wrapProgram $out/bin/dwm \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath old.buildInputs}
    '';
  });

  mySt = pkgs.st.overrideAttrs (old: {
    src = ../suckless/st;
  });

  myDmenu = pkgs.dmenu.overrideAttrs (old: {
    src = ../suckless/dmenu;
  });
in
{
  # X11 with French AZERTY layout
  services.xserver = {
    enable = true;
    xkb.layout = "br";

    windowManager.dwm = {
      enable = true;
      package = myDwm;
    };

    displayManager.lightdm.enable = true;
  };

  environment.systemPackages = [
    mySt
    myDmenu
    pkgs.slock
    pkgs.slstatus

  ] ++ (with pkgs; [
    # Build dependencies (para compilar manualmente)
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    xorg.libXres
    gcc
    gnumake
    pkg-config
    harfbuzz
    imlib2
    libXrandr
    libxcb
    libxcb-wm
    libxcb-util
    libxcb-image
    gd
    fontconfig
  ]);
}
