{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nixfmt
              pkgs.nodejs_24
            ];
          };
          packages.firefox-dev = pkgs.firefox-devedition.override {
            extraPolicies = {
              BlockAboutConfig = true;
              "3rdparty".Extensions."addon@darkreader.org" = {
                syncSettings = false;
                disabledFor = ["news.ycombinator.com"];
              };
            };
          };
        };
    };
}
