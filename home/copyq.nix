{ config, pkgs, ... }:

let
  # Pega o home do usuário
  homeDir = config.home.homeDirectory or "/home/anderson";
in
{
  home.packages = with pkgs; [
    copyq
  ];

  systemd.user.services.copyq = {
    Unit = {
      Description = "CopyQ Clipboard Manager";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      # Adiciona condição para só iniciar se tiver DISPLAY
      ConditionEnvironment = "DISPLAY";
    };

    Service = {
      Type = "simple";
      # Usa caminho absoluto em vez de %h
      ExecStart = "${pkgs.copyq}/bin/copyq --config-dir ${homeDir}/.config/copyq";
      Restart = "on-failure";
      RestartSec = 3;
      TimeoutStopSec = 10;
      # Melhor definir o DISPLAY assim
      Environment = [
        "DISPLAY=:0"
        "QT_QPA_PLATFORM=xcb"
      ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Ativa o serviço
  systemd.user.services.copyq.enable = true;
}
