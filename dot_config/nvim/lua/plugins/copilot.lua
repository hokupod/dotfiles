return {
  "zbirenbaum/copilot.lua",
  config = function()
    require("copilot").setup {
      filetypes = {
        lua = true,
        ruby = true,
        php = true,
        go = true,
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        svelte = true,
        astro = true,
        html = true,
        css = true,
        ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
      },
    }
  end,
}
