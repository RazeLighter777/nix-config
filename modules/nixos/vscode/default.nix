{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.vscode.enable {
    programs.nix-ld.enable = true;

    home-manager.users.${config.my.user.name}.programs = {
      vscode = {
        enable = true;

        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            github.copilot
            github.copilot-chat
            arrterian.nix-env-selector
            ms-vscode-remote.remote-ssh
            rust-lang.rust-analyzer
            ms-python.python
            esbenp.prettier-vscode
            ms-azuretools.vscode-docker
            ms-vscode.cpptools
            ecmel.vscode-html-css
            redhat.vscode-yaml
            jnoortheen.nix-ide
          ];

          userSettings = {
            "editor.definitionLinkOpensInPeek" = false;
            "editor.gotoLocation.multipleDefinitions" = "goto";
            "editor.gotoLocation.multipleImplementations" = "goto";
            "editor.gotoLocation.multipleTypeDefinitions" = "goto";
            "editor.gotoLocation.multipleReferences" = "goto";
            "workbench.editor.enablePreview" = false;
            "workbench.editor.enablePreviewFromQuickOpen" = false;
          };
        };
      };
    };
  };
}
