{ config, pkgs, lib, ... }:

let
  myDwm = pkgs.dwm.overrideAttrs (old: {
    src = ../suckless/dwm;
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

    # Build dependencies for compiling suckless tools locally
    pkgs.xorg.libX11
    pkgs.xorg.libXft
    pkgs.xorg.libXinerama
    pkgs.xorg.libXres
    pkgs.gcc
    pkgs.gnumake
    pkgs.pkg-config
    pkgs.harfbuzz
    pkgs.imlib2
    pkgs.libXrandr
    pkgs.libxcb
    pkgs.libxcb-wm
    pkgs.libxcb-util
    pkgs.libxcb-image
    pkgs.libxcb-util
    pkgs.gd
  ];
}
