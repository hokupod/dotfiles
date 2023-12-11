local status, treesitter = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

treesitter.setup {
  ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "svelte", "html", "ruby", "go", "zig", },
  highlight = {
    enable = true, -- ハイライトを有効化
    additional_vim_regex_highlighting = false, -- catpuucin用
    disable = {},
  },
  indent ={
    enable =true,
  },
  autotag = {
    enable = true,
  },
}
