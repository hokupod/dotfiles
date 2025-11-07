return {
  "johmsalas/text-case.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "gC.", "<cmd>TextCaseOpenTelescope<CR>", desc = "Telescope", mode = { "n", "x" } },
  },
  config = function()
    require("textcase").setup({
      prefix = "gC",
    })
    require("telescope").load_extension("textcase")
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

