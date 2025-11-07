return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<space>:", "<cmd>Telescope command_history<cr>", desc = "[Telescope] command_history" },
    { "<space>/", "<cmd>Telescope search_history<cr>", desc = "[Telescope] search_history" },
    { "<space>b", "<cmd>Telescope buffers<cr>", desc = "[Telescope] buffers" },
    { "<space>c", "<cmd>Telescope colorscheme<cr>", desc = "[Telescope] colorscheme" },
    { "<space>h", "<cmd>Telescope highlights<cr>", desc = "[Telescope] highlights" },
    { "<space>k", "<cmd>Telescope keymaps<cr>", desc = "[Telescope] keymaps" },
    { "<space>u", "<cmd>Telescope oldfiles<cr>", desc = "[Telescope] oldfiles" },
    { "<space>q", "<cmd>Telescope quickfix<cr>", desc = "[Telescope] quickfix" },
    { "<space>gf", "<cmd>Telescope git_files<cr>", desc = "[Telescope] git_files" },
    { "<space>gc", "<cmd>Telescope git_commits<cr>", desc = "[Telescope] git_commits" },
    { "<space>gb", "<cmd>Telescope git_branches<cr>", desc = "[Telescope] git_branches" },
    { "<space>gs", "<cmd>Telescope git_status<cr>", desc = "[Telescope] git_status" },
    { "<space>gS", "<cmd>Telescope git_stash<cr>", desc = "[Telescope] git_status" },
    { "<space>gg", "<cmd>Telescope live_grep<cr>", desc = "[Telescope] live_grep" },
    { "<space>ff", "<cmd>Telescope find_files<cr>", desc = "[Telescope] find_files" },
    { "<space>ft", "<cmd>Telescope filetypes<cr>", desc = "[Telescope] filetypes" },
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

    local set = vim.keymap.set
    
    -- These need to be set this way because they require function calls
    set("n", "<space>z", extensions("z", "list")({}), { desc = "[Telescope] z" })
    set("n", "<space>gh", extensions("ghq", "list")({}), { desc = "[Telescope] ghq" })
  end,
}
