{ pkgs, ... }:
{
  home-manager.users.justin.programs.vscode = {
	        enable = true;
        package = (pkgs.vscode.override{ isInsiders = true; }).overrideAttrs (oldAttrs: rec {
      src = (builtins.fetchTarball {
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        sha256 = "1m33pryga586sqwyn1hkl9d6b3a1k9qb35fl5qzbpjk8yrnx52y2";
      });
      version = "latest";
    });
        extensions = with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
          yzhang.markdown-all-in-one
          github.copilot
          rust-lang.rust-analyzer
          arrterian.nix-env-selector
          vue.volar
          dbaeumer.vscode-eslint
          jnoortheen.nix-ide
        ];
	};
}
