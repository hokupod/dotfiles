-- https://github.com/epwalsh/obsidian.nvim/issues/286
vim.opt.conceallevel = 1

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
local daily_notes_dir = "02_Daily"

local function get_latest_file(directory)
  local files = vim.fn.readdir(directory)
  if #files == 0 then
    return nil
  end

  table.sort(files, function(a, b)
    return a > b
  end)

  local latest_file = files[1]
  local todays_file = os.date("%Y-%m-%d") .. ".md"

  if latest_file == todays_file then
    return files[2]
  end
  return files[1]
end
local latest_daily_note = get_latest_file(vault_path .. "/" .. daily_notes_dir )
local latest_daily_note_full = vault_path .. "/" .. daily_notes_dir .. "/" .. latest_daily_note

-- Number of seconds in a day
local DAY_SECONDS = 86400

-- Returns the date for the next working day
local function next_daily_note()
  local weekday = tonumber(os.date("%w"))

  if weekday == 5 then  -- Friday
    return os.date("%Y-%m-%d", os.time() + (DAY_SECONDS * 3))
  elseif weekday == 6 then  -- Saturday
    return os.date("%Y-%m-%d", os.time() + (DAY_SECONDS * 2))
  end

  return os.date("%Y-%m-%d", os.time() + DAY_SECONDS)
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
    substitutions = {
      next_daily_note = next_daily_note,
      yesterday = function()
        return os.date("%Y-%m-%d", os.time() - 86400)
      end,
      tomorrow = function()
        return os.date("%Y-%m-%d", os.time() + 86400)
      end,
      daily_title = function()
        return os.date("%Y年%m月%d日 %a")
      end,
      now = function()
        return os.date('%Y-%m-%d %H:%M')
      end,
      latest_daily_note = function()
        return latest_daily_note:gsub(".md", "")
      end
    }
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
    folder = daily_notes_dir,
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d",
    -- Optional, if you want to change the date format of the default alias of daily notes.
    alias_format = "%B %-d, %Y",
    -- Optional, default tags to add to each new daily note created.
    default_tags = {},
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    template = "DailyVim.md",
  },
  attachments = {
    img_folder = "90_Extra",
    ---@return string
    img_name_func = function()
      -- Prefix image names with timestamp.
      return string.format("%s-", os.time())
    end,
  },
  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,
    -- Trigger completion at 2 chars.
    min_chars = 2,
  },
  callbacks = {
    -- Runs right before writing the buffer for a note.
    pre_write_note = function(client, note)
      -- Update the modified field of the note
      note:add_field("modified", os.date('%Y-%m-%d %H:%M'))
    end,
  },
}

local function is_markdown()
  return vim.bo.filetype == 'markdown'
end
local wk = require("which-key")
local ob = require("obsidian")
wk.add({
  { "<leader>o", group = "Obsidian", mode = { "n", }, },
  { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "[Obsidian] New" },
  { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "[Obsidian] Today's Daily Note" },
  { "<leader>ol", "<cmd>edit " .. latest_daily_note_full .. "<cr>", desc = "[Obsidian] Latest Daily Note" },
  { "<leader>oc", ob.util.toggle_checkbox, desc = "[Obsidian] Toggle Checkbox", },
  { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "[Obsidian] Follow Link", },
})
vim.keymap.set("n", "gf", function()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "gf"
  end
end, { noremap = false, expr = true })

vim.cmd([[cab on ObsidianNew]])
vim.cmd([[cab ot ObsidianToday]])

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = "*",
--   callback = function()
--     print("FileType: " .. vim.bo.filetype)
--     print("is_markdown(): " .. tostring(is_markdown()))
--   end,
-- })
