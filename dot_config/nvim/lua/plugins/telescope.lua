return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
  },
  config = function()
    -- Telescope
    local telescope = require("telescope")
    local function extensions(name, prop)
      return function(opt)
        return function()
          telescope.load_extension(name)
          return telescope.extensions[name][prop](opt or {})
        end
      end
    end

    local defaults = {
      layout_config = {
        prompt_position = "bottom",
      },
      file_ignore_patterns = {
        "node_modules",
        ".git",
        ".cache",
        ".DS_Store",
        ".yarn",
      },
      mappings = {
        i = {
          ["<C-a>"] = require("telescope.actions").toggle_all,
        },
        n = {
          ["<C-a>"] = require("telescope.actions").toggle_all,
        },
      },
    }

    require("telescope").setup({
      defaults = defaults,
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function(opts)
            return { "--hidden" }
          end,
        },
      },
    })

    telescope.load_extension("messages")
    require("telescope").extensions.messages.setup({
      register = "+",
    })

    local builtin = require("telescope.builtin")
    local set = vim.keymap.set
    local wk = require("which-key")
    wk.add({
      mode = { "n" },
      noremap = true,
      silent = true,
      { "<space>", group = "Telescope" },
      { "<space>:", builtin.command_history, desc = "[Telescope] command_history" },
      { "<space>/", builtin.search_history, desc = "[Telescope] search_history" },
      { "<space>b", builtin.buffers, desc = "[Telescope] buffers" },
      { "<space>c", builtin.colorscheme, desc = "[Telescope] colorscheme" },
      { "<space>h", builtin.highlights, desc = "[Telescope] highlights" },
      { "<space>k", builtin.keymaps, desc = "[Telescope] keymaps" },
      { "<space>u", builtin.oldfiles, desc = "[Telescope] oldfiles" },
      { "<space>q", builtin.quickfix, desc = "[Telescope] quickfix" },
      { "<space>z", extensions("z", "list")({}), desc = "[Telescope] z" },

      { "<space>g", group = "+git" },
      { "<space>gf", builtin.git_files, desc = "[Telescope] git_files" },
      { "<space>gc", builtin.git_commits, desc = "[Telescope] git_commits" },
      { "<space>gb", builtin.git_branches, desc = "[Telescope] git_branches" },
      { "<space>gs", builtin.git_status, desc = "[Telescope] git_status" },
      { "<space>gS", builtin.git_stash, desc = "[Telescope] git_status" },
      { "<space>gg", builtin.live_grep, desc = "[Telescope] live_grep" },
      { "<space>gh", extensions("ghq", "list")({}), desc = "[Telescope] ghq" },

      { "<space>f", group = "+file" },
      { "<space>ff", builtin.find_files, desc = "[Telescope] find_files" },
      { "<space>ft", builtin.filetypes, desc = "[Telescope] filetypes" },
    })
  end,
}
