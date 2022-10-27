local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
g.mapleader = " "

opt.termguicolors = true
opt.mouse = 'a'
opt.relativenumber = true
require("bufferline").setup{}
require("which-key").setup{}
require("nvim-tree").setup{}
require("nvim-web-devicons").setup{
	default = true;
	}
require("toggleterm").setup{ 
  open_mapping = [[<c-\>]],
  direction = 'float',
 }

local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
map("n", "<leader>t", "<cmd>Telescope<CR>",opts)
