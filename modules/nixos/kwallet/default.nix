{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.kwallet;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.kdePackages.kwallet
      pkgs.kdePackages.kwalletmanager
      pkgs.kdePackages.kwallet-pam
      pkgs.kdePackages.ksshaskpass
      pkgs.kwalletcli
    ];

    xdg.portal.extraPortals = [ pkgs.kdePackages.kwallet ];
    xdg.portal.config = {
      common."org.freedesktop.impl.portal.Secret" = [ "kwallet" ];
      Hyprland."org.freedesktop.impl.portal.Secret" =
        lib.mkIf config.my.hyprland.enable [ "kwallet" ];
    };

    programs.ssh.askPassword =
      "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

    systemd.user.services."dbus-org.freedesktop.secrets.kwallet" = {
      description =
        "Allow KWallet to be D-Bus activated for the generic org.freedesktop.secrets API";
      serviceConfig = {
        Type = "dbus";
        ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
        BusName = "org.freedesktop.secrets";
      };
      aliases = [
        "dbus-org.freedesktop.secrets.service"
        "dbus-org.kde.kwalletd5.service"
      ];
    };

    services.dbus.packages = [
      (pkgs.writeTextFile {
        name = "org.freedesktop.secrets.kwallet.service";
        destination = "/share/dbus-1/services/org.freedesktop.secrets.service";
        text = ''
          [D-BUS Service]
          Name=org.freedesktop.secrets
          SystemdService=dbus-org.freedesktop.secrets.service
        '';
      })
    ];

    home-manager.users.${config.my.user.name} = {
      home.sessionVariables = {
        SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
        SSH_ASKPASS_REQUIRE = "prefer";
      };
      systemd.user.services.pam-kwallet-init = lib.mkIf config.services.displayManager.sddm.enable {
        Unit = {
          Description = "Initialize KWallet PAM session";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };

    security.pam.services = lib.mkMerge [
      (lib.mkIf (
        config.services.displayManager.sddm.enable
        && config.services.displayManager.autoLogin.enable
        && !config.my.displayManager.enable
      ) {
        sddm-autologin.kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
          forceRun = true;
        };
        sddm-autologin.rules.session.kwallet.settings.auto_start = true;
      })
      (lib.mkIf (
        config.services.displayManager.sddm.enable
        && !config.services.displayManager.autoLogin.enable
      ) {
        sddm.kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
          forceRun = true;
        };
        sddm.rules.session.kwallet.settings.auto_start = true;
      })
      {
        login.kwallet = {
          enable = true;
          forceRun = true;
          package = pkgs.kdePackages.kwallet-pam;
        };
        login.rules.session.kwallet.settings.auto_start = true;
      }
    ];
  };
}
