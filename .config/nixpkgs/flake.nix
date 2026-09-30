# INFO: packages we want to install the nix way
#     - add this file to your system with `nix profile add "path:$HOME/.config/nixpkgs"`
#     - upgrade with                      `nix profile upgrade nixpkgs
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";

      # INFO: Get a newer astal commit. the one in ags is old as fuck
      inputs.astal = {
        url = "github:aylur/astal";
        inputs.nixpkgs.follows = "ags/nixpkgs";
      };
    };
  };

  outputs = { nixpkgs, ags, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      astal = ags.inputs.astal.packages.${system};

      # INFO: Load our hyprland patch
      patchedHyprland = astal.hyprland.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (pkgs.fetchurl {
            name = "astal-hyprland-monitor-fix.patch";
            url = "https://github.com/DeusProx/astal/commit/dc6aaddb05b7d783ec1f815230a8afe7116cb98a.patch";
            hash = "sha256-Q9sew3GlM/k6ni6+8SnfRwhBFyO4sXgDfn5I7a61INc=";
          })
        ];

        # The package source starts at lib/hyprland.
        patchFlags = [ "-p3" ];
      });

      agsFull = ags.packages.${system}.agsFull.override (old: {
        extraPackages = map
          (package: if package == astal.hyprland then patchedHyprland else package)
          old.extraPackages;
      });
    in {
      packages.${system} = {
        inherit agsFull;

        # INFO: Add further packages here
        default = pkgs.buildEnv {
          name = "user-packages";
          paths = [
            pkgs.nixos-rebuild
            agsFull
          ];
        };
      };
    };
}

