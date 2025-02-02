return {
  { "nvzone/menu", lazy = true },
  { "nvzone/volt", lazy = true },
  config = function()
    require("menu").setup()
    vim.keymap.set("n", "<C-t>", function()
      require("menu").open("default")
    end, {})

    vim.keymap.set("n", "<RightMouse>", function()
      vim.cmd.exec('"normal! \\<RightMouse>"')

      local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
      require("menu").open(options, { mouse = true })
    end, {})
  end,
}
