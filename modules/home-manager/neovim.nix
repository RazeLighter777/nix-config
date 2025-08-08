{ pkgs, ... }:
{
  home-manager.users.justin.programs.neovim = {
	enable = true;
	viAlias = true;
	vimAlias = true;
	plugins = [
		pkgs.vimPlugins.lazy-nvim
	];
  };
}
