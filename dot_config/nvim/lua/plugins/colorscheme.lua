return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local colorscheme = "tokyonight"
    local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    vim.o.background = "dark"
    vim.g.background = "dark"
    if ok then
      require("lualine").setup({
        options = { theme = "auto" },
      })
    else
      vim.notify("colorscheme " .. colorscheme .. " not found!")
    end
  end,
}
