HOST ?= zenbox
FLAKE ?= .#$(HOST)
FLAGS ?=

.PHONY: commit dry-run build switch test diff list-hosts help all

commit:
	git add -A
	git commit -m "update: $(shell date -Iseconds)" || echo "(nothing to commit)"

dry-run:
	nixos-rebuild dry-run --flake $(FLAKE) $(FLAGS)

build:
	nixos-rebuild build --flake $(FLAKE) $(FLAGS)

switch:
	sudo nixos-rebuild switch --flake $(FLAKE) $(FLAGS)

test:
	sudo nixos-rebuild test --flake $(FLAKE) $(FLAGS)

diff: build
	sudo nix store diff-closures /run/current-system result || true

list-hosts:
	@echo "Available hosts:" && grep -E '^[[:space:]]*[a-zA-Z0-9_-]+ =' flake.nix | sed -n 's/^[[:space:]]*\([^ ]*\) =.*/\1/p'

all: commit switch

help:
	@echo "Makefile targets:"; \
	echo "  HOST=<name> make dry-run   # Evaluate and show what would build"; \
	echo "  HOST=<name> make build     # Build system closure only"; \
	echo "  HOST=<name> make switch    # Build + activate"; \
	echo "  HOST=<name> make test      # Build + temporary activate"; \
	echo "  HOST=<name> make diff      # Show closure diff after build"; \
	echo "  make list-hosts            # Parse host names from flake.nix"; \
	echo "Variables:"; \
	echo "  HOST (default: zenbox)"; \
	echo "  FLAGS='--impure' (if you really need impure eval)";