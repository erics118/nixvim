set shell := ["zsh", "-uc"]

# list all commands
default:
	@just --list

# update all flake inputs
update:
	nix flake update

# format nix files
fmt:
	find . -type f -name "*.nix" -exec nixfmt {} \;

# check flake
check:
    nix flake check .

# run nixvim
run:
    nix run .
