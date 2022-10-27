{ pkgs, ...}:

{
#nixpkgs.overlays = [
  #(import (builtins.fetchTarball {
  #  url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  #  }))
  #  ];
xdg.enable = true;
xdg.configFile."i3/config".text = builtins.readFile ./i3;
home.packages = with pkgs; [
  bottom
  fasd
  fd
  ripgrep
  fzf
  exa
  bitwarden
];
home.sessionVariables.Editor = "nvim";
programs.neovim = {
  enable = true;
  plugins = with pkgs.vimPlugins;[
  telescope-nvim
  nvim-treesitter
  nvim-lspconfig
  nvim-tree-lua
  nvim-web-devicons
  rust-tools-nvim
  nvim-cmp
  cmp-nvim-lsp
  vim-commentary
  which-key-nvim
  packer-nvim
  toggleterm-nvim
  bufferline-nvim

  ];
  
  extraConfig = "lua << EOF\n" + builtins.readFile ./init.lua + "\nEOF";
  };
programs.tmux = {
  enable = true;
  extraConfig = builtins.readFile ./tmux.conf;
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
    };

  };
  programs.mpv = {
    enable = true;
    };
  home.stateVersion = "22.05";
}
