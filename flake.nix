{
  description = "WSL Ubuntu Dotfiles (Nix)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations = {
        # Replace 'user' with your actual username if different, 
        # or pass it via command line: --argstr user <username>
        # For now we default to 'user' or the current user.
        # Usage: home-manager switch --flake .#<username>
        
        # We'll use a generic name 'wsl' or try to match the user.
        # Since I don't know the exact username the user will use in the future,
        # I'll create a configuration named 'osiic' (based on the path) and a generic 'user'.
        
        osiic = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
        
        # Generic fallback
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
