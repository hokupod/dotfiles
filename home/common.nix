{ pkgs, ... }: {
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    vim
    curl
    wget
    ripgrep
    mise
    neovim
    rust-bin.stable.latest.default
    direnv
    nix-direnv
  ];

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    git.settings = {
        enable = true;
        userName = "hokupod";
        userEmail = "hokupod@outlook.com";
    };
  };
}
