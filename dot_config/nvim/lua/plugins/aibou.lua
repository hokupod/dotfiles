return {
  "atusy/aibou.nvim",
  dependencies = {
    "olimorris/codecompanion.nvim",
  },
  config = function()
    vim.keymap.set("n", "<leader>ai", function()
      require("aibou.codecompanion").start({
        codecompanion = {
          chat_args = {
            adapter = "gemini",
          },
        },
      })
    end, { desc = "Start aibou" })
  end,
}
