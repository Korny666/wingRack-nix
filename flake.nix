{
  inputs = {
    nixpkgs.url = "github:Korny666/nixpkgs?ref=wing-mix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    my-nvim = {
      url = "github:korny666/nvim-nix";
    };
  };
  outputs =
    {
      nixpkgs,
      disko,
      my-nvim,
      ...
    }:
    {
      # Use this for all other targets
      #
      # Fist time without hardware-configuration:
      # nixos-anywhere --flake .#nixos --generate-hardware-config nixos-generatn e-config ./hardware-configuration.nix <hostname>
      #
      # full reinstall with existing hardware-configuration:
      # nixos-anywhere --flake .#nixos <hostname>
      #
      # updates as usual with:
      # nixos-rebuild --flake .\#nixos --target-host root@192.168.188.53 boot
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          my-nvim.nixosModules.default
          disko.nixosModules.disko
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };
}
