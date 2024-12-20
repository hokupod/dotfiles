require("textcase").setup({
  prefix = "gC",
})
require("which-key").add({
  {
    mode = { "n", "x" },
    { "gC", group = "text-case" },
    { "gC.", "<cmd>TextCaseOpenTelescope<CR>", desc = "Telescope" },
  },
})
