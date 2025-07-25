{ ... }:
{
  home-manager.users.justin.programs.bash = {
    enable = true;
    shellAliases = {
      # Add your shell aliases here
      ll = "ls -l";
      la = "ls -la";
      k = "kubectl";
    };
  };
}
