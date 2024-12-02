local home_dir = vim.fn.expand('$HOME/')
local vault_path = home_dir .. 'Documents/obsidian_vault'
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
else
  -- for WSL
  if vim.fn.system('uname -a | grep -i microsoft') ~= '' then
    local win_home_dir = vim.fn.expand('$WINHOME/')
    vault_path = win_home_dir .. 'Documents/obsidian_vault'
  end
end
require("obsidian").setup {
  workspaces = {
    {
      name = 'default',
      path = vault_path,
    },
  },
  templates = {
    folder = "99_Templates",
  },
  notes_subdir = "01_Inbox",
  note_id_func = function(title)
    local timestamp = os.date('%Y-%m-%d_%H-%M-%S')
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = "_" .. title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    end
    return timestamp .. suffix
  end,
  daily_notes = {
    -- Optional, if you keep daily notes in a separate directory.
    folder = "02_Daily",
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d",
    -- Optional, if you want to change the date format of the default alias of daily notes.
    alias_format = "%B %-d, %Y",
    -- Optional, default tags to add to each new daily note created.
    default_tags = {},
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = "daily.md",
  },
  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,
    -- Trigger completion at 2 chars.
    min_chars = 2,
  },
}
