commit:
	git add -A 
	git commit -m "change `date`"
rebuild:
    sudo nixos-rebuild switch --flake .#hostName --impure
all: commit rebuild