return {
  "vim-denops/denops.vim",
  "folke/neodev.nvim",
  {
    "nacro90/numb.nvim",
    opts = {},
  },
  "lewis6991/gitsigns.nvim",
  "machakann/vim-sandwich",
  "glidenote/memolist.vim",
  "mattn/vim-findroot",
  "cohama/lexima.vim",
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
  "tpope/vim-commentary",
  { "tpope/vim-rails", ft = {"ruby", "eruby"} },
  "kevinhwang91/nvim-bqf",
  "lambdalisue/fern.vim",
  "echasnovski/mini.icons",
  "nvim-tree/nvim-web-devicons",
  {
    "stevearc/oil.nvim",
    opts = {},
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "yamatsum/nvim-cursorline",
    config = function()
      require("nvim-cursorline").setup({
        cursorline = {
          enable = true,
          timeout = 1000,
          number = false,
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = { underline = true },
        },
      })
    end,
  },
  {
    "asiryk/auto-hlsearch.nvim",
    tag = "1.1.0",
    opts = {},
  },
  {
    "skanehira/jumpcursor.vim",
    config = function()
      vim.keymap.set("n", "z", "<Plug>(jumpcursor-jump)")
    end,
  },
  "rhysd/clever-f.vim",
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      vim.diagnostic.config({ virtual_text = false })
      require("tiny-inline-diagnostic").setup()
    end,
  },
  -- Syntax Highlighting
  "sheerun/vim-polyglot",
  "wuelnerdotexe/vim-astro",
  "evanleck/vim-svelte",
  "leafOfTree/vim-svelte-plugin",
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup({
        nextls = { enable = true },
        elixirls = {
          enable = true,
          settings = elixirls.settings({
            dialyzerEnabled = false,
            enableTestLenses = false,
          }),
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
          end,
        },
        projectionist = {
          enable = true,
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "andersevenrud/nvim_context_vt",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- Git
  "lambdalisue/vim-gin",
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
  },
  -- Translate
  {
    "uga-rosa/translate.nvim",
    cmd = "Translate",
    opts = {},
  },
  -- AI
  {
    "zbirenbaum/copilot-cmp",
    opts = {},
  },
  {
    "MeanderingProgrammer/render-markdown.nvim", -- Make Markdown buffers look beautiful
    ft = { "markdown", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      render_modes = true, -- Render in ALL modes
      sign = {
        enabled = false, -- Turn off in the status column
      },
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      right = {
        { ft = "codecompanion", title = "Code Companion Chat", size = { width = 0.45 } },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {},
  },
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   tag = "0.1.4",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  -- },
  "nvim-telescope/telescope-ghq.nvim",
  "nvim-telescope/telescope-z.nvim",
  {
    "prochri/telescope-all-recent.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "kkharji/sqlite.lua",
      -- optional, if using telescope for vim.ui.select
      "stevearc/dressing.nvim",
    },
    opts = {},
  },
  {
    "junegunn/fzf",
    cmd = { "Fzf" },
    setup = function()
      vim.fn["fzf#install"]()
    end,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
  },
  {
    "https://github.com/atusy/treemonkey.nvim",
    init = function()
      vim.keymap.set({ "x", "o" }, "m", function()
        require("treemonkey").select({ ignore_injections = false })
      end)
    end,
  },
  -- LSP
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
    },
  },
  {
    "creativenull/efmls-configs-nvim",
    version = "v1.9.0", -- version is optional, but recommended
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "lukas-reineke/lsp-format.nvim",
    opts = {},
  },
  "mfussenegger/nvim-lint",
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  "aznhe21/actions-preview.nvim",
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
}
