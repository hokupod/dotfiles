return {
  "johmsalas/text-case.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "folke/which-key.nvim",
  },
  config = function()
    require("textcase").setup({
      prefix = "gC",
    })
    require("telescope").load_extension("textcase")
    require("which-key").add({
      {
        mode = { "n", "x" },
        { "gC", group = "text-case" },
        { "gC.", "<cmd>TextCaseOpenTelescope<CR>", desc = "Telescope" },
      },
    })
  end,
  cmd = {
    -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
    "Subs",
    "TextCaseOpenTelescope",
    "TextCaseOpenTelescopeQuickChange",
    "TextCaseOpenTelescopeLSPChange",
    "TextCaseStartReplacingCommand",
  },
  lazy = false,
}

