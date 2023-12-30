local vault_dir
if vim.fn.system('uname -a | grep -i microsoft') ~= '' then
  vault_dir = vim.fn.expand("$WINHOME/Documents/obsidian_vault/")
else
  vault_dir = vim.fn.expand("$HOME/Documents/obsidian_vault/")
end
local workspaces = {
  {
    name = "p",
    path = vault_dir .. "Private",
  },
  {
    name = "w",
    path = vault_dir .. "Work",
  },
}

local day_sec = 86400
local month_sec = 2592000
local year_sec = 31536000
local tmp_today = os.date("*t", os.time())

-- Summarizing various elements of today's date
---@type table
local today = {
    year = tmp_today.year,
    month = tmp_today.month,
    day = tmp_today.day,
    -- zero padding
    z_month = string.format("%02d", tmp_today.month),
    -- zero padding
    z_day = string.format("%02d", tmp_today.day),
}

require("obsidian").setup {
  workspaces = workspaces,
  notes_subdir = "Notes",
  detect_cwd = false,
  disable_frontmatter = true,
  templates = {
    subdir = "Template",
    date_format = "%Y年%m月%d日",
    substitutions = {
      -- YYYY年MM月DD日
      today = function()
        local year = today.year
        local month = today.z_month
        local day = today.z_day
        return (year .. "年" .. month .. "月" .. day .. "日")
      end,
      -- YYYY/MM/DD
      today_fm_1 = function()
        local year = today.year
        local month = today.z_month
        local day = today.z_day
        return (year .. "/" .. month .. "/" .. day)
      end,
      -- YYYY/M/D
      today_fm_2 = function()
        local year = today.year
        local month = today.month
        local day = today.day
        return (year .. "/" .. month .. "/" .. day)
      end,
      -- YYYY年M月D日
      today_fm_3 = function()
        local year = today.year
        local month = today.month
        local day = today.day
        return (year .. "年" .. month .. "月" .. day .. "日")
      end,
      -- YYYY-MM-DD
      today_fm_4 = function()
        local year = today.year
        local month = today.z_month
        local day = today.z_day
        return (year .. "-" .. month .. "-" .. day)
      end,
      -- YYYY-M-D
      today_fm_5 = function()
        local year = today.year
        local month = today.month
        local day = today.day
        return (year .. "-" .. month .. "-" .. day)
      end,
      -- Tomorrow
      tomorrow = function()
        local tmp = os.date("*t", os.time() + day_sec)
        local year = tmp.year
        local month = string.format("%02d", tmp.month)
        local day = string.format("%02d", tmp.day)
        return (year .. "年" .. month .. "月" .. day .. "日")
      end,
      -- Yesterday
      yesterday = function()
        local tmp = os.date("*t", os.time() - day_sec)
        local year = tmp.year
        local month = string.format("%02d", tmp.month)
        local day = string.format("%02d", tmp.day)
        return (year .. "年" .. month .. "月" .. day .. "日")
      end,
      -- YYYY年MM月
      current_month = function()
        local year = today.year
        local month = today.z_month
        return (year .. "年" .. month .. "月")
      end,
      -- YYYY/MM
      month_fm_1 = function()
        local year = today.year
        local month = today.z_month
        return (year .. "/" .. month)
      end,
      -- YYYY/M
      month_fm_2 = function()
        local year = today.year
        local month = today.month
        return (year .. "/" .. month)
      end,
      -- YYYY-MM
      month_fm_3 = function()
        local year = today.year
        local month = today.z_month
        return (year .. "-" .. month)
      end,
      -- YYYY-M
      month_fm_4 = function()
        local year = today.year
        local month = today.month
        return (year .. "-" .. month)
      end,
      -- YYYY年M月
      month_fm_5 = function()
        local year = today.year
        local month = today.month
        return (year .. "年" .. month .. "月")
      end,
      -- Next month
      next_month = function()
        local tmp = os.date("*t", os.time() + month_sec + day_sec)
        local year = tmp.year
        local month = string.format("%02d", tmp.month)
        return (year .. "年" .. month .. "月")
      end,
      -- Last month
      last_month = function()
        local tmp = os.date("*t", os.time() - month_sec)
        local year = tmp.year
        local month = string.format("%02d", tmp.month)
        return (year .. "年" .. month .. "月")
      end,
      -- YYYY年
      current_year = function()
        local year = today.year
        return (year .. "年")
      end,
      -- Next year
      next_year = function()
        local tmp = os.date("*t", os.time() + year_sec)
        local year = tmp.year
        return (year .. "年")
      end,
      -- Last year
      last_year = function()
        local tmp = os.date("*t", os.time() - year_sec)
        local year = tmp.year
        return (year .. "年")
      end,
    },
  },
  daily_notes = {
    -- Optional, if you keep daily notes in a separate directory.
    folder = "Notes/Dailies",
    -- Optional, if you want to change the date format for the ID of daily notes.
    date_format = "%Y-%m-%d",
    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
    -- NOTE: Should without `Templates/`
    template = "daily.md"
  },
  completion = {
    nvim_cmp = true,
    min_chars = 2,
    -- Where to put new notes created from completion. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "notes_subdir",

    -- Control how wiki links are completed with these (mutually exclusive) options:
    --
    -- 1. Whether to add the note ID during completion.
    -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
    -- Mutually exclusive with 'prepend_note_path' and 'use_path_only'.
    --prepend_note_id = true,
    -- 2. Whether to add the note path during completion.
    -- E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
    -- Mutually exclusive with 'prepend_note_id' and 'use_path_only'.
    --prepend_note_path = true,
    -- 3. Whether to only use paths during completion.
    -- E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
    -- Mutually exclusive with 'prepend_note_id' and 'prepend_note_path'.
    use_path_only = true,
  },

  -- Set to true if you use the Obsidian Advanced URI plugin.
  -- https://github.com/Vinzent03/obsidian-advanced-uri
  use_advanced_uri = true,

  open_app_foreground = false,

  -- Setting the finder to use
  -- Comment out what you don't use
  finder = "telescope.nvim",
  --finder = "fzf-lua",
  --finder = "fzf.nvim",
  --finder = "fzf.vim",

  -- Sort search results by "path", "modified", "accessed", or "created".
  sort_by = "modified",
  sort_reversed = true,

  -- Open note in current buffer
  open_notes_in = "current",

  -- Optional, set the YAML parser to use. The valid options are:
  --  * "native" - uses a pure Lua parser that's fast but potentially misses some edge cases.
  --  * "yq" - uses the command-line tool yq (https://github.com/mikefarah/yq), which is more robust
  --    but much slower and needs to be installed separately.
  -- In general you should be using the native parser unless you run into a bug with it, in which
  -- case you can temporarily switch to the "yq" parser.
  yaml_parser = "native",
}

-- Keybind
local wk = require("which-key")
wk.register({
  o = {
    name = "Obsidian",
    t = { "<cmd>ObsidianToday<CR>", '[Obsidian] Open today note' },
    y = { "<cmd>ObsidianYesterday<CR>", '[Obsidian] Open yesterday note' },
    l = { "<cmd>ObsidianQuickSwitch<CR>", '[Obsidian] Open in current workspace file' },
    s = { "<cmd>ObsidianSearch<CR>", '[Obsidian] Search in current workspace' },
    w = {
      name = "+workspace",
      p = { "<cmd>ObsidianWorkspace p<CR>", '[Obsidian] Open private workspace', silent=false },
      w = { "<cmd>ObsidianWorkspace w<CR>", '[Obsidian] Open work workspace', silent=false },
      c = { "<cmd>ObsidianWorkspace<CR>", '[Obsidian] Show current workspace', silent=false },
    }
  },
}, {
  mode = "n",
  prefix = "<leader>",
})
