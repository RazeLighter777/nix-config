{ pkgs, ... }:
{
  home-manager.users.justin.programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      github.copilot
      github.copilot-chat
      arrterian.nix-env-selector
      ms-vscode-remote.remote-ssh
      rust-lang.rust-analyzer
      ms-python.python
      vue.vscode-typescript-vue-plugin
      esbenp.prettier-vscode
      ms-azuretools.vscode-docker
      ms-vscode.cpptools
      ecmel.vscode-html-css
      redhat.vscode-yaml
      bbenoist.nix
    ];
  };
}
