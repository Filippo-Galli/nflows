{
  description = "nflows package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    UMNN = {
      url = "github:Filippo-Galli/UMNN";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      UMNN,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          torchtestcase = pkgs.callPackage ./torchtestcase.nix { };
        in
        {
          nflows = pkgs.callPackage ./. {
            UMNN = inputs.UMNN.packages.${system}.default;
            inherit torchtestcase;
          };

          default = self.packages.${system}.nflows;
        }
      );
    };
}
