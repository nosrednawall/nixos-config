{ config, pkgs, lib, ... }:

let
# Bibliotecas dos pacotes
#
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


  slockLibs = with pkgs; [
    libX11
    libxcrypt
    libXext
    libXrandr
    libXinerama
    imlib2
    libxcb
    libXft
    libXrender
    freetype
    xcb-proto
    libxcb-image
    libXau
    libXdmcp
    libz
    libpng
  ];


  dwmblocksLibs = with pkgs; [
    libxcb-util
    libxcb
    libXau
    libXdmcp
  ];

  # Gera o pacote myDwm
  myDwm = pkgs.dwm.overrideAttrs (old: {
    src = ../suckless/dwm;
    buildInputs = baseLibs ++ dwmLibs;

  });

  mySt = pkgs.st.overrideAttrs (old: {
    src = ../suckless/st;
    buildInputs = baseLibs ++ stLibs;
  });

 myDmenu = pkgs.dmenu.overrideAttrs (old: {
    src = ../suckless/dmenu;
    buildInputs = baseLibs ++ dmenuLibs;
 });

 mySlock = pkgs.slock.overrideAttrs (old: {
    buildInputs = baseLibs ++ slockLibs;
    src = ../suckless/slock;
  });


 # Construção do dwmblocks-async
 myDwmblocks = pkgs.stdenv.mkDerivation (old:  {
    name = "dwmblocks-async";
    src = ../suckless/dwmblocks-async;

    buildInputs = baseLibs ++ dwmblocksLibs ++ [
      pkgs.pkg-config
      pkgs.gcc
      pkgs.gnumake
    ];

    # Configurações do Makefile
    makeFlags = [
      "PREFIX=$(out)"
    ];

    # Compilação
    buildPhase = ''
      runHook preBuild
      make
      runHook postBuild
    '';

    # Instalação
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp build/dwmblocks $out/bin/dwmblocks
      runHook postInstall
    '';

 });

  potato-c = pkgs.stdenv.mkDerivation {
    pname = "potato-c";
    version = "0.7.1";
    src = ../suckless/potato-c;

    nativeBuildInputs = with pkgs; [ pkg-config pandoc ];
    buildInputs = with pkgs; [ ncurses ];

    preBuild = "cp config.def.h config.h";

    makeFlags = [
      "PREFIX=${placeholder "out"}"
      "MANPREFIX=${placeholder "out"}/share/man"
      "sysconfigdir=${placeholder "out"}/share"
    ];

    installPhase = ''
      mkdir -p $out/bin $out/share/man/man1 $out/share/potato-c
      cp bin/* $out/bin/
      cp doc/*.1 $out/share/man/man1/ 2>/dev/null || true
      cp on-*.sh $out/share/potato-c/ 2>/dev/null || true
    '';
  };

in
{
# Desabilita o slock do nixos
  programs.slock.enable = false;

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
    mySlock
    potato-c
    #pkgs.slock
    pkgs.slstatus
    pkgs.xinit
  ];

  security.wrappers = {
    mySlock = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${mySlock}/bin/slock";
    };
  };

}
