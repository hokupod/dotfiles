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

opt.undodir = vim.fn.expand('$HOME/.vim_undo')
opt.undofile = true

if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  -- バックアップパスを Windows 用に設定
  opt.backupdir = 'G:/マイドライブ/vim_backup'
  opt.directory = 'G:/マイドライブ/vim_backup'
else
  -- バックアップパスを nix 系 OS 用に設定
  opt.backupdir = vim.fn.expand('$HOME/.vim_backup')
  opt.directory = vim.fn.expand('$HOME/.vim_backup')

  -- for WSL
  if vim.fn.system('uname -a | grep -i microsoft') ~= '' then
    opt.backupdir = '/mnt/g/マイドライブ/vim_backup'
    opt.directory = '/mnt/g/マイドライブ/vim_backup'
  end
end


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

-- Keymap
local set = vim.keymap.set
set("i", "jj", "<ESC>")
set("n", "x", '"_x')
set("n", "X", '"_x')
set("v", "x", '"_x')
set("v", "X", '"_x')

local vimscript = [[
""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
""""""""""""""""""""""""""""""
if has("autocmd")
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\ exe "normal! g'\"" |
\ endif
endif

""""""""""""""""""""""""""""""
" 保存時に行末の空白を除去する
""""""""""""""""""""""""""""""
function! s:RemoveSpaceAtEOL()
  let cursor = getpos(".")
  if &filetype != "markdown"
    %s/\s\+$//ge
  endif
  %s/\r$//ge
  call setpos(".", cursor)
  unlet cursor
endfunction
autocmd BufWritePre * call <SID>RemoveSpaceAtEOL()
]]
vim.cmd(vimscript)

require("auto-hlsearch").setup()
