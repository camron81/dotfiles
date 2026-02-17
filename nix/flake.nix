{
  description = "My NixOS Configurations";

  inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    inputs@{
      flake-parts,
      import-tree,
      home-manager,
      nixpkgs,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports =
        let
          getFiles = (import-tree.withLib nixpkgs.lib).leafs;
        in
        [
          flake-parts.flakeModules.modules
          home-manager.flakeModules.home-manager
        ]
        ++ (getFiles ./hosts)
        ++ (getFiles ./modules)
        ++ (getFiles ./users);
    };
}
