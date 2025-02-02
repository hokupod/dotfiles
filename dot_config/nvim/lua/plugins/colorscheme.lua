return {
  "yorickpeterse/nvim-grey",
  dependencies = {
    "nvim-lualine/lualine.nvim",
  },
  config = function()
    local colorscheme = "grey"
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
