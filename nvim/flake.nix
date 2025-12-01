{
  description = "Osiic's Neovim config";

  outputs = { self, nixpkgs }: {
    # Module khusus home-manager
    homeManagerModules.nvim = { config, pkgs, lib, ... }: {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        # Bisa tambahin plugin langsung dari nixpkgs juga
        plugins = with pkgs.vimPlugins; [
          vim-nix
          telescope-nvim
          nvim-treesitter
        ];

        # Ambil langsung init.lua / init.vim dari repo ini
        extraLuaConfig = builtins.readFile ./init.lua;
      };
    };
  };
}
