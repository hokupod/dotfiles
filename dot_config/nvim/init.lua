function is_git_repo()
  local _ = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
  return vim.v.shell_error == 0
end

-- vim.g.mapleader = " "

local home_dir = vim.fn.expand("$HOME/")
local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.title = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.hlsearch = true
opt.showcmd = true
opt.helplang = "ja"
opt.termguicolors = true

opt.showtabline = 2
opt.signcolumn = "yes:3"
opt.expandtab = true
opt.smarttab = true
opt.shiftwidth = 2
opt.tabstop = 2

opt.shell = os.getenv("SHELL")
opt.swapfile = false

opt.undodir = home_dir .. ".vim_undo"
opt.undofile = true

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- バックアップパスを Windows 用に設定
  opt.backupdir = "G:/マイドライブ/vim_backup"
  opt.directory = "G:/マイドライブ/vim_backup"
else
  -- バックアップパスを nix 系 OS 用に設定
  opt.backupdir = home_dir .. ".vim_backup"
  opt.directory = home_dir .. ".vim_backup"

  -- for WSL
  if vim.fn.system("uname -a | grep -i microsoft") ~= "" then
    opt.backupdir = "/mnt/g/マイドライブ/vim_backup"
    opt.directory = "/mnt/g/マイドライブ/vim_backup"
  end
end

-- .inc を PHP として扱う
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.inc",
  callback = function()
    vim.opt.filetype = "php"
  end,
})

-- .astro を Astro として扱う
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.astro",
  callback = function()
    vim.opt.filetype = "astro"
  end,
})

-- Keymap
local set = vim.keymap.set
set("i", "jj", "<ESC>")
set("n", "x", '"_x')
set("n", "X", '"_x')
set("v", "x", '"_x')
set("v", "X", '"_x')
set("n", "<C-j>", function()
  vim.diagnostic.jump({ count = 1, float = false })
end)
set("n", "<C-k>", function()
  vim.diagnostic.jump({ count = -1, float = false })
end)
set("n", "<M-l>", ":tabnext<CR>")
set("n", "<M-h>", ":tabprevious<CR>")

-- MemoList
vim.g.memolist_fzf = 1
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  vim.g.memolist_path = "G:\\マイドライブ\\memolist"
elseif vim.fn.has("wsl") == 1 then
  vim.g.memolist_path = "/mnt/g/マイドライブ/memolist"
else
  vim.g.memolist_path = home_dir .. "memolist"
end

set("n", "<space>mm", ":MemoNew<CR>")
set("n", "<space>ml", ":MemoList<CR>")
set("n", "<space>mg", ":MemoGrep<CR>")

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

autocmd VimEnter * ++once
      \ call matchadd('ExtraWhitespace', "[\u00A0\u2000-\u200B\u3000]")
      \ | highlight default ExtraWhitespace ctermbg=darkmagenta guibg=darkmagenta
]]
vim.cmd(vimscript)

-- CAPS LOCK
vim.keymap.set("i", "<C-l>", function()
  local line = vim.fn.getline(".")
  local col = vim.fn.getpos(".")[3]
  local substring = line:sub(1, col - 1)
  local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
  return "<C-w>" .. result:upper()
end, { expr = true })

require("config.lazy")
