{ config, pkgs, ... }:

{
  # Ativa o Polkit
  security.polkit.enable = true;

  # Instala o pacote
  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];

  # Configura o serviço systemd do sistema (não do usuário)
  systemd.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical.target" ];
    wants = [ "graphical.target" ];
    after = [ "graphical.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
