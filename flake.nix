{
  description = "Cross-platform dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, neovim-nightly, nur, rust-overlay, ... }: {
    homeConfigurations = {
      "mac" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [
            neovim-nightly.overlays.default
            nur.overlays.default
            rust-overlay.overlays.default
          ];
        };
        modules = [
          ./home/common.nix
          ./home/darwin.nix
          {
            home.username = "hokuto";
            home.homeDirectory = "/Users/hokuto";
          }
        ];
      };
    };
  };
}
