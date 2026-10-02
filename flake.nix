{
  description = "nflows package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    UMNN = {
      url = "github:Filippo-Galli/UMNN";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    torchtestcase = {
      url = "github:Filippo-Galli/torch-test-case";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      UMNN,
      torchtestcase,
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
        in
        {
          nflows = pkgs.callPackage ./. {
            UMNN = inputs.UMNN.packages.${system}.default;
            torchtestcase = inputs.torchtestcase.packages.${system}.default;
          };

          default = self.packages.${system}.nflows;
        }
      );
    };
}
