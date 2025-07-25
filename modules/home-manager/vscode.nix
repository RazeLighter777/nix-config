{ pkgs, ... }:
{
  home-manager.users.justin.programs.vscode = {
	        enable = true;
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
