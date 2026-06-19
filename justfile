set shell := ["zsh", "-uc"]

# list all commands
[private]
default:
    @just --list --unsorted

# update all flake inputs
[group('flake')]
update-all:
    nix flake update

# update a single flake input
[group('flake')]
update input:
    nix flake update {{ input }}

# format the repo
[group('flake')]
fmt:
    nix fmt

# check flake outputs
[group('flake')]
check:
    nix flake check

# run nixvim
[group('nixvim')]
run *args:
    nix run . -- {{ args }}
