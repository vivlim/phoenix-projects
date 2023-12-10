{
  description = "A Nix-flake-based Elixir development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = (with pkgs; [ elixir nodejs ]) ++
            # Linux only
            pkgs.lib.optionals (pkgs.stdenv.isLinux) (with pkgs; [ inotify-tools libnotify ]);
        };
      });
    };
}
