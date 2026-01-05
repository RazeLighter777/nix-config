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
        profiles.default = {
          isDefault = true;
          settings = {
            "mailnews.send_plaintext_flowed" = false;
            "mailnews.wraplength" = 0;
          };
        };
      };
    };
  };
}
