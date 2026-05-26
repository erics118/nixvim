set shell := ["zsh", "-uc"]

# list all commands
default:
	@just --list

# update all flake inputs
update:
	nix flake update

# format the repo
fmt:
	nix fmt

# check flake
check:
    nix flake check .

# run nixvim
run *args:
    nix run . -- {{args}}
