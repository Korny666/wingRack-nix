{
  inputs = {
    nixpkgs.url = "github:ck3d/nixpkgs?ref=x32edit-43";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };
  outputs =
    {
      nixpkgs,
      disko,
      nixos-facter-modules,
      ...
    }:
    {
      # Use this for all other targets
      #
      # Fist time without hardware-configuration:
      # nixos-anywhere --flake .#nixos --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      #
      # full reinstall with existing hardware-configuration:
      # nixos-anywhere --flake .#nixos <hostname>
      #
      # updates as usual with:
      # nixos-rebuild --flake .\#nixos --target-host root@192.168.188.53 boot
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };
}
