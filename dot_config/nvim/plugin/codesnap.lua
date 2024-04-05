local codesnap = require('codesnap')
local home_dir = vim.fn.expand('$HOME/')
local save_path = ''
local cmd = ''

if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
  -- バックアップパスを Windows 用に設定
  save_path = 'G:/マイドライブ/codesnap'
  cmd = 'explorer "' .. save_path .. '"'
else
  -- バックアップパスを nix 系 OS 用に設定
  save_path = home_dir .. '.codesnap'
  cmd = 'xdg-open "' .. save_path .. '" || open "' .. save_path .. '"'
end

local function open_codesnap_dir()
  vim.fn.system(cmd)
end
vim.api.nvim_create_user_command('CodeSnapOpenDir', open_codesnap_dir, {})

codesnap.setup({
  has_breadcrumb = true,
  save_path = save_path .. '/codesnap.png',
  watermark = 'hokupod - made by CodeSnap.nvim',
})
