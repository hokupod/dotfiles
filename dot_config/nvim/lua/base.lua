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

-- Fern
vim.cmd([[
let g:fern#renderer = 'nerdfont'
]])

local wk = require("which-key")
wk.add({
  { "<leader>f", group = "Filer" },
  { "<leader>f.", "<cmd>Fern . -reveal=% -drawer -toggle -width=40<CR>", desc = "[Filer] Open current directory" },
})

-- Trouble
wk.add({
  { "<leader>x", group = "Trouble" },
  { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "[Trouble] Document Diagnostics" },
  { "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "[Trouble] Loclist" },
  { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "[Trouble] Quickfix" },
  { "<leader>xr", "<cmd>TroubleToggle lsp_references<CR>", desc = "[Trouble] LSP References" },
  { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "[Trouble] Workspace Diagnostics" },
  { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "[Trouble] Toggle" },
})

-- dial.nvim
local augend = require("dial.augend")
local baseAugends = {
  augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
  augend.integer.alias.hex,     -- nonnegative hex number  (0x01, 0x1a1f, etc.)
  augend.date.alias["%Y/%m/%d"],
  augend.date.alias["%Y-%m-%d"],
  augend.date.alias["%m/%d"],
  augend.date.alias["%H:%M"],
  augend.constant.alias.ja_weekday,
  augend.constant.alias.ja_weekday_full,
  augend.constant.alias.bool,
}
local mergeAugents = function(tbl)
  local merged = {}
  for k, v in pairs(baseAugends) do merged[k] = v end
  for k, v in pairs(tbl) do merged[k] = v end
  return merged
end
require("dial.config").augends:register_group {
  default = baseAugends,
  javascript = mergeAugents({
    augend.constant.new { elements = { "let", "const" } },
  }),
}

vim.cmd([[
" 複数のファイルタイプで同じ設定を有効にする
autocmd FileType typescript,typescriptreact,javascript,javascriptreact,astro,svelte lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("javascript"), {noremap = true})
autocmd FileType typescript,typescriptreact,javascript,javascriptreact,astro,svelte lua vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("javascript"), {noremap = true})
]])

vim.keymap.set("n", "<C-a>", function()
  require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
  require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "<C-a>", function()
  require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
  require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gvisual")
end)

-- modesearch.vim
vim.cmd([[
nmap g/ <Plug>(modesearch-slash)
nmap g? <Plug>(modesearch-question)
cmap <C-x> <Plug>(modesearch-toggle-mode)
]])
