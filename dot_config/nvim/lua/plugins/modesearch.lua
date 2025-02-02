return {
  "monaqa/modesearch.vim",
  dependencies = {},
  config = function()
    -- modesearch.vim
    vim.cmd([[
    nmap g/ <Plug>(modesearch-slash)
    nmap g? <Plug>(modesearch-question)
    cmap <C-x> <Plug>(modesearch-toggle-mode)
    ]])
  end,
}
