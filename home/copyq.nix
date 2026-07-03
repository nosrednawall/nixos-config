{ config, pkgs, ... }:

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
      ConditionEnvironment = "DISPLAY";
    };

    Service = {
      Type = "simple";
      # Adiciona a flag --start-server para iniciar o servidor
      ExecStart = "${pkgs.copyq}/bin/copyq --start-server --config-dir %h/.config/copyq";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 10;
      Environment = [
        "DISPLAY=:0"
        "QT_QPA_PLATFORM=xcb"
      ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
