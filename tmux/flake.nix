{
  description = "Osiic's tmux config";

  outputs = { self, nixpkgs }: {
    # Module khusus home-manager
    homeManagerModules.tmux = { config, pkgs, lib, ... }: {
      programs.tmux = {
        enable = true;

        # Bisa masih pake default setting tambahan
        shortcut = "a";
        keyMode = "vi";
        mouse = true;

        # Tarik langsung isi tmux.conf dari repo ini
        extraConfig = builtins.readFile ./tmux.conf;
      };
    };
  };
}
