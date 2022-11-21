{pkgs, ...}: let
  unstable = import <unstable> {};
in {

  #nixpkgs.overlays = [
  #(import (builtins.fetchTarball {
  #  url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  #  }))
  #  ];
  xdg.enable = true;
  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."polybar/config".text = builtins.readFile ./polybar;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  home.packages = with pkgs; [
    bottom
    fasd
    fd
    ripgrep
    fzf
    exa
    bitwarden
    rust-analyzer
    clang
    #   unstable.neovim
    tree-sitter
    lazygit
    haskellPackages.greenclip
  ];
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  programs.neovim = {
    #package = unstable.neovim-unwrapped;
    enable = true;
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      nvim-treesitter
      nvim-lspconfig
      nvim-tree-lua
      nvim-web-devicons
      rust-tools-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp-vsnip
      vim-vsnip
      cmp-nvim-lua
      lsp_signature-nvim
      vim-commentary
      which-key-nvim
      packer-nvim
      toggleterm-nvim
      bufferline-nvim
      onedark-nvim
      lazygit-nvim
    ];
    extraConfig = "lua << EOF\n" + builtins.readFile ./neovim/init.lua + "\nEOF";
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05
  #programs.direnv.nix-direnv.enableFlakes = true;
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
  programs.rofi = {
    enable =true;
    extraConfig = {
      modi = "run,ssh,filebrowser,window";
      show-icons = true;
      sort = true;
      matching = "fuzzy";
    };
  };

  programs.brave = {
    enable = true;
  };
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
  };

  programs.git = {
    enable = true;
    userName = "Per Johansson";
    userEmail = "per.a.johansson@svt.se";
    extraConfig = {
      url."git@git.svt.se:".insteadof = "https://git.svt.se/";
      github.user = "perilainen";
      push.default = "tracking";
      pull.rebase = true;
      rebase.autosquash = true;
      branch.autosetuprebase = "always";
      rebase.autostash = true;
    };
  };
  programs.mpv = {
    enable = true;
  };
  programs.fish = {
    enable = true;
    shellAbbrs = {
      g = "git";
    };
    #shellInit = ''
    #set -x LIBCLANG_PATH "${pkgs.llvmPackages.libclang}/lib";
    #''
  };
  # xresources.extraConfig = builtins.readFile ./Xresources;

  home.sessionVariables.Editor = "nvim";
  home.stateVersion = "22.05";
}
