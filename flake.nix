{
  description = "KlipperZscreen";

  inputs = {
    nixpkgs.url =
      "git+file:///home/vesim/pro/nixpkgs"; # "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls";
  };
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      overlays = [
        (final: prev: {
          zigpkgs = inputs.zig.packages.${prev.system};
          zls = inputs.zls.packages.${prev.system}.zls;
        })
      ];

      systems = builtins.attrNames inputs.zig.packages;
    in flake-utils.lib.eachSystem systems (system:
      let pkgs = import nixpkgs { inherit overlays system; };
      in with pkgs; rec {
        devShells.default = pkgs.mkShell {
          buildInputs = [ zigpkgs."0.12.0" pkg-config gdb SDL2 SDL2_image zls ];
        };
      });
}
