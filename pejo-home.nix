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
     (writeShellScriptBin "rofi-beats" ''
    ${builtins.readFile ./scripts/rofi-beats.sh}
     '')
     (writeShellScriptBin "rofi-main" ''
    ${builtins.readFile ./scripts/rofi-main.sh}
     '')
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
      bufferline-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp-vsnip
      lazygit-nvim
      lsp_signature-nvim
      markdown-preview-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-tree-lua
      nvim-treesitter
      nvim-web-devicons
      onedark-nvim
      packer-nvim
      rust-tools-nvim
      telescope-nvim
      toggleterm-nvim
      vim-commentary
      vim-vsnip
      which-key-nvim
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
