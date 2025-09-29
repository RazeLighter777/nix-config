{ config, lib, ... }:
{
  config = lib.mkIf config.my.bash.enable {
    home-manager.users.${config.my.user.name}.programs.bash = { enable = true; shellAliases = { ll = "ls -l"; la = "ls -la"; k = "kubectl"; }; };
  };
}
