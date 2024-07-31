local codesnap = require('codesnap')
local home_dir = vim.fn.expand('$HOME/')
local save_path = ''
local cmd = ''

if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  -- 保存用フォルダを Windows の TEMP フォルダに設定
  save_path = vim.fn.expand('$TEMP/codesnap')
  -- codesnap ディレクトリが存在しない場合は作成
  if vim.fn.isdirectory(save_path) == 0 then
    vim.fn.mkdir(save_path, 'p')
  end
  cmd = 'explorer "' .. save_path .. '"'
else
  -- 保存用ディレクトリを nix 系 OS 用に設定
  save_path = home_dir .. '.codesnap'
  -- codesnap ディレクトリが存在しない場合は作成
  if vim.fn.isdirectory(save_path) == 0 then
    vim.fn.mkdir(save_path, 'p')
  end
  cmd = 'xdg-open "' .. save_path .. '" || open "' .. save_path .. '"'
end

local function open_codesnap_dir()
  vim.fn.system(cmd)
end
vim.api.nvim_create_user_command('CodeSnapOpenDir', open_codesnap_dir, {})

local function save_and_open_codesnap_dir()
  vim.cmd('\'<,\'>CodeSnapSave')
  open_codesnap_dir()
end
vim.api.nvim_create_user_command('CodeSnapSaveAndOpenDir', save_and_open_codesnap_dir, {range = true})

local wk = require("which-key")
wk.add({
  { "<leader>c", group = "CodeSnap" },
  { "<leader>cd", ":<C-u>CodeSnapOpenDir<CR>", desc = "Open CodeSnap Directory" },
})

wk.add({
  { "<leader>c", group = "CodeSnap", mode = "v" },
  { "<leader>cc", ":<C-u>CodeSnapSaveAndOpenDir<CR>", desc = "Save and Open CodeSnap Directory", mode = "v" },
})

codesnap.setup({
  has_breadcrumb = true,
  save_path = save_path .. '/codesnap.png',
  watermark = 'hokupod - made by CodeSnap.nvim',
})

