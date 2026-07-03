{ config, pkgs, lib, ... }:

let
  myDwm = pkgs.dwm.overrideAttrs (old: {
    src = ../suckless/dwm;
    buildInputs = (old.buildInputs or []) ++ [
      pkgs.makeWrapper  # ← ADICIONE ISTO!
      pkgs.xorg.libX11
      pkgs.xorg.libXinerama
      pkgs.xorg.libXft
      pkgs.xorg.libXrender
      pkgs.xorg.libXres
      pkgs.xorg.libXrandr
      pkgs.libxcb
      pkgs.libxcb-wm
      pkgs.libxcb-util
      pkgs.libxcb-image
      pkgs.fontconfig
      pkgs.xorg.libXext
      pkgs.xorg.libXpm
      pkgs.imlib2
      pkgs.gd
      pkgs.gcc
      pkgs.gnumake
      pkgs.pkg-config
      pkgs.harfbuzz
      pkgs.imlib2
      pkgs.libXrandr
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
    buildInputs = (old.buildInputs or []) ++ [
      pkgs.makeWrapper
      pkgs.xorg.libX11
      pkgs.xorg.libXft
      pkgs.xorg.libXinerama
    ];
    postInstall = ''
      wrapProgram $out/bin/dmenu \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath old.buildInputs}
      # Também wrap do stest (usado pelo dmenu_run)
      wrapProgram $out/bin/stest \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
    '';
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
    pkgs.xinit
  ];
}
