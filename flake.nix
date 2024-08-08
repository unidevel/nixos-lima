{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, nixos-generators, ... }@attrs: 
    # Create system-specific outputs for lima systems
    let
      ful = flake-utils.lib;
    in
    ful.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          img = nixos-generators.nixosGenerate {
            inherit pkgs;
            modules = [
              ./lima.nix
            ];
            format = "raw-efi";
          };
	  default = self.packages.${system}.img;
        };
      }) // { 
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux"; # doesn't play nice with each system :shrug:
          specialArgs = attrs;
          modules = [
            ./lima.nix
            ./user-config.nix
          ];
        };

        nixosModules.lima = {
          imports = [ ./lima.nix ];
        };
      };
}
