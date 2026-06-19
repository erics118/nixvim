{
  description = "A Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit system; # or alternatively, set `pkgs`
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              # inherit (inputs) foo;
              isDarwin = inputs.nixpkgs.lib.strings.hasInfix "darwin" system;
              utils = {
                requireDependencies = config: pluginName: deps: {
                  assertion =
                    config.plugins.${pluginName}.enable
                    -> (inputs.nixpkgs.lib.all (d: config.plugins.${d}.enable) deps);
                  message = ''
                    Nixvim Error: '${pluginName}' is enabled but is missing dependencies.
                    Required plugins: ${inputs.nixpkgs.lib.concatStringsSep ", " deps}
                    Ensure all of these are set to '.enable = true;'
                  '';
                };

                # keymap helper for plugin modules
                mkMap = mode: key: action: desc: {
                  inherit mode key action;
                  options = {
                    noremap = true;
                    silent = true;
                    inherit desc;
                  };
                };
              };
            };
          };
          nvim = nixvim'.makeNixvimWithModule nixvimModule;
        in
        {
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          };

          packages = {
            # Lets you run `nix run .` to start nixvim
            default = nvim;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              nvim
              config.treefmt.build.wrapper
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";

            settings = {
              excludes = [
                "result"
                "result-*"
                "flake.lock"
              ];
              on-unmatched = "info";
            };

            programs = {
              nixfmt.enable = true;
              nixfmt.strict = true;
              deadnix.enable = true;
              statix.enable = true;

              prettier.enable = true;
              just.enable = true;
            };
          };
        };
    };
}
