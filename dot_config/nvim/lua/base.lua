local home_dir = vim.fn.expand('$HOME/')
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

opt.undodir = home_dir .. '.vim_undo'
opt.undofile = true

if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  -- バックアップパスを Windows 用に設定
  opt.backupdir = 'G:/マイドライブ/vim_backup'
  opt.directory = 'G:/マイドライブ/vim_backup'
else
  -- バックアップパスを nix 系 OS 用に設定
  opt.backupdir = home_dir .. '.vim_backup'
  opt.directory = home_dir .. '.vim_backup'

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

-- .inc を PHP として扱う
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.inc",
  callback = function()
    vim.opt.filetype = "php"
  end,
})

-- Keymap
local set = vim.keymap.set
set("i", "jj", "<ESC>")
set("n", "x", '"_x')
set("n", "X", '"_x')
set("v", "x", '"_x')
set("v", "X", '"_x')

-- MemoList
vim.g.memolist_fzf = 1
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  vim.g.memolist_path = "G:\\マイドライブ\\memolist"
elseif vim.fn.has('wsl') == 1 then
  vim.g.memolist_path = "/mnt/g/マイドライブ/memolist"
else
  vim.g.memolist_path = home_dir .. 'memolist'
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

require("auto-hlsearch").setup()

-- auto-session
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
require("auto-session").setup {
  log_level = "error",

  cwd_change_handling = {
      post_cwd_changed_hook = function()
        require("lualine").refresh()
      end,
    },
}

-- Fern
vim.cmd([[
let g:fern#renderer = 'nerdfont'
]])

local wk = require("which-key")
wk.register({
  f = {
    name = "Filer",
    ["."] = { "<cmd>Fern . -reveal=% -drawer -toggle -width=40<CR>", "[Filer] Open current directory" },
  },
}, {
  mode = "n",
  prefix = "<leader>",
})

-- Trouble
wk.register({
  x = {
    name = "Trouble",
    ["x"] = { "<cmd>TroubleToggle<CR>", "[Trouble] Toggle" },
    ["w"] = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "[Trouble] Workspace Diagnostics" },
    ["d"] = { "<cmd>TroubleToggle document_diagnostics<CR>", "[Trouble] Document Diagnostics" },
    ["q"] = { "<cmd>TroubleToggle quickfix<CR>", "[Trouble] Quickfix" },
    ["l"] = { "<cmd>TroubleToggle loclist<CR>", "[Trouble] Loclist" },
    ["r"] = { "<cmd>TroubleToggle lsp_references<CR>", "[Trouble] LSP References" },
  },
}, {
  mode = "n",
  prefix = "<leader>",
})
