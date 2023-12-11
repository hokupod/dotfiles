local opt = vim.opt
opt.clipboard = 'unnamedplus'
opt.mouse = 'a'
opt.title = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.hlsearch = true
opt.showcmd = true
opt.helplang = 'ja'
opt.termguicolors = true

opt.showtabline = 2
opt.signcolumn = 'yes'
opt.expandtab = true
opt.smarttab = true
opt.shiftwidth = 2
opt.tabstop = 2

opt.shell = 'fish'
opt.swapfile = false

local colorscheme = "everforest"
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
vim.o.background = "dark" -- or "light" for light mode
if ok then
  require('lualine').setup {
    options = { theme = colorscheme },
  }
else
  vim.notify("colorscheme " .. colorscheme .. " not found!")
end

local set = vim.keymap.set
set("i", "jj", "<ESC>")

require("auto-hlsearch").setup()
