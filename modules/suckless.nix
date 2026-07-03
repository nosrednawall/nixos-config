{ config, pkgs, lib, ... }:

let

  baseLibs = with pkgs; [
     makeWrapper
  ];

  dwmLibs = with pkgs; [
      libXinerama
      libXft
      libxcb
      libXext
      imlib2
  ];

  stLibs = with pkgs; [
      libconfig
      libXft
      harfbuzz
      imlib2
      libXcursor
  ];

  dmenuLibs = with pkgs; [
    libXinerama
    libXft
  ];


  dwmblocksLibs = with pkgs; [
    libXinerama
    libXft
  ];

  myDwm = pkgs.dwm.overrideAttrs (old: {
    src = ../suckless/dwm;
    buildInputs = baseLibs ++ dwmLibs;

    # Isto vai criar um wrapper que aponta para as bibliotecas corretas
    postInstall = ''
      wrapProgram $out/bin/dwm \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath old.buildInputs}
    '';
  });

  mySt = pkgs.st.overrideAttrs (old: {
    src = ../suckless/st;
    buildInputs = baseLibs ++ stLibs;
    postInstall = ''
      wrapProgram $out/bin/st \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath old.buildInputs}
    '';
  });

 myDmenu = pkgs.dmenu.overrideAttrs (old: {
    src = ../suckless/dmenu;
    buildInputs = baseLibs ++ dmenuLibs;
    postInstall = ''
      wrapProgram $out/bin/dmenu \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath old.buildInputs}
      # Também wrap do stest (usado pelo dmenu_run)
      wrapProgram $out/bin/stest \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath old.buildInputs}
    '';
 });

 myDwmblocks = pkgs.dwmblocks.overrideAttrs (old: {
    src = ../suckless/dwmblocks-async;
    buildInputs = baseLibs ++ dwmblocksLibs;
    postInstall = ''
      wrapProgram $out/bin/dwmblocks \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath old.buildInputs}
    '';
  });

in
{
  # X11 with French AZERTY layout
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    windowManager.dwm = {
      enable = true;
      package = myDwm;
    };

    displayManager.lightdm.enable = true;
  };

  environment.systemPackages = [
    mySt
    myDmenu
    myDwmblocks
    pkgs.slock
    pkgs.slstatus
    pkgs.xinit

  ];
}
