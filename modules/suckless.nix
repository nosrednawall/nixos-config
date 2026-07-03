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
    xcb-proto  #  libX11-xcb
    libxcb-image  #    libxcb-shm
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

    # Wrapper para bibliotecas
    postInstall = ''
      wrapProgram $out/bin/dwmblocks \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath old.buildInputs}
    '';
 });

in
{

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
    #pkgs.slock
    pkgs.slstatus
    pkgs.xinit
    (pkgs.runCommand "slock" {} ''
      mkdir -p $out/bin
      ln -s ${mySlock}/bin/slock $out/bin/slock
    '')
  ];

  security.wrappers = {
    mySlock = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${mySlock}/bin/slock";
    };
  };

  programs.slock = {
      enable = true;
      package = mySlock
  };

}
