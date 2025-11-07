return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {},
  keys = {
    { "<leader>xd", "<cmd>Trouble diagnostics toggle<CR>", desc = "[Trouble] Document Diagnostics in Workspace" },
    {
      "<leader>xD",
      "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "[Trouble] Document Diagnostics in Current Buffer",
    },
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
      desc = "[Trouble] LSP Definitions / references / ... ",
    },
    { "<leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "[Trouble] Loclist" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "[Trouble] Symbols" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "[Trouble] Quickfix List" },
    { "<leader>xx", "<cmd>Trouble<CR>", desc = "[Trouble] Menu" },
  },
}
