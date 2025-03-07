return {
  "zenbones-theme/zenbones.nvim",
  dependencies = {
    "rktjmp/lush.nvim",
  },
  lazy = false,
  priority = 1000,
  config = function()
    local colorscheme = "zenbones"
    local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    vim.o.background = "light"
    vim.g.background = "light"
    if ok then
      require("lualine").setup({
        options = { theme = "auto" },
      })
    else
      vim.notify("colorscheme " .. colorscheme .. " not found!")
    end
  end,
}
