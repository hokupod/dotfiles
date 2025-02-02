return {
  "shortcuts/no-neck-pain.nvim",
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>n", group = "NoNeckPain" },
      { "<leader>nd", "<cmd>NoNeckPainWidthDown<CR>", desc = "[NoNeckPain] Width Down" },
      { "<leader>nn", "<cmd>NoNeckPain<CR>", desc = "[NoNeckPain] Toggle" },
      { "<leader>nu", "<cmd>NoNeckPainWidthUp<CR>", desc = "[NoNeckPain] Width Up" },
    })
  end,
}
