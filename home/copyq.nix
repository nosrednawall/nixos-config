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
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.copyq}/bin/copyq --config-dir %h/.config/copyq";
      Restart = "on-failure";
      RestartSec = 3;
      Environment = "DISPLAY=:0";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
