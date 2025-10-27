{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.my.thunderbird.enable {
    home-manager.users.${config.my.user.name} = {
      programs.thunderbird = {
        enable = true;
        package = pkgs.thunderbird;
        profiles.default = {
          isDefault = true;
          settings = {
            # Enable automatic updates
            "app.update.auto" = true;

            # Privacy settings
            "privacy.donottrackheader.enabled" = true;
            "privacy.trackingprotection.enabled" = true;

            # Performance settings
            "general.smoothScroll" = true;

            # Enable dark theme detection
            "ui.systemUsesDarkTheme" = 1;

            # Calendar settings
            "calendar.week.start" = 1; # Start week on Monday

            # Security settings
            "mail.smtpserver.default.try_ssl" = 3; # Require SSL/TLS
            "mail.server.default.check_new_mail" = true;

            # UI improvements
            "mailnews.default_sort_order" = 2; # Sort by date, descending
            "mail.ui.folderpane.showTotal" = true; # Show total message count
          };
        };
      };
    };
  };
}

