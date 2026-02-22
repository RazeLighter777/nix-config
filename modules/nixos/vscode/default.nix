{
  config,
  lib,
  pkgs,
  ...
}:

let
  vscode1092 = pkgs.vscode.overrideAttrs (old: {
    version = "1.109.2";
    src = pkgs.fetchurl {
      name = "vscode.tar.gz";
      url = "https://code.visualstudio.com/sha/download?os=linux-x64";
      sha256 = "sha256-ST5i8gvNtAaBbmcpcg9GJipr8e5d0A0qbdG1P9QViek=";
    };
  });
in
{
  config = lib.mkIf config.my.vscode.enable {
    programs.nix-ld.enable = true;

    home-manager.users.${config.my.user.name}.programs = {
      vscode = {
        enable = true;
        package = vscode1092;

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
            "editor.formatOnSave" = true;
            "workbench.editor.enablePreview" = false;
            "workbench.editor.enablePreviewFromQuickOpen" = false;
          };
        };
      };
    };
  };
}
