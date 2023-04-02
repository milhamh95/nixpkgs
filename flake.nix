{
    descriptipn = "Nix system configs";

    inputs = {
        # Package sets
        nixpkgs-master.url = "github:NixOS/nixpkgs/master";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.11";

         # Other sources / nix utilities
        flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
        flake-utils.url = "github:numtide/flake-utils";

        # Environment / system management

        # Nix darwin
        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";  

        # Home manager
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
        home-manager.inputs.utils.follows = "flake-utils";
        
        # Utility for watching macOS `defaults`.
        prefmanager.url = "github:malob/prefmanager";
        prefmanager.inputs.nixpkgs.follows = "nixpkgs-unstable";
        prefmanager.inputs.flake-compat.follows = "flake-compat";
        prefmanager.inputs.flake-utils.follows = "flake-utils";
    };

    outputs = { self, darwin, home-manager, flake-utils, ...}@inputs:
        let
            inherit (self.lib) attrValues makeOverridable optionalAttrs singleton;

            nixPkgsDefaults = {
                config = {
                    allowUnfree = true;
                };
                overlays = attrValues self.overlays
                    ++ singleton (inputs.prefmanager.overlays.prefmanager);
            };

            # Personal configuration shared between `nix-darwin` and plain `home-manager` configs.
            homeManagerStateVersion = "23.05";

            primaryUserDefaults = rec {
                username = "ilham";
                fullName = "Muhammad Ilham Hidayat";
                email = "photon628@gmail.com";
                nixConfigDirectory = "/Users/${username}/.config/nixpkgs";
            };
        in
        {
            
        }
}