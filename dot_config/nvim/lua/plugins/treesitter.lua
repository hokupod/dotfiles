return {
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    local status, treesitter = pcall(require, "nvim-treesitter.configs")
    if not status then
      return
    end

    treesitter.setup({
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "astro",
        "svelte",
        "html",
        "ruby",
        "go",
        "zig",
        "markdown",
        "markdown_inline",
        "yaml",
      },
      highlight = {
        enable = true, -- ハイライトを有効化
        additional_vim_regex_highlighting = false, -- catpuucin用
        disable = {},
      },
      indent = {
        enable = true,
      },
    })
  end,
}
