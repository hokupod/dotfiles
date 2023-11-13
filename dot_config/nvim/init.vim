set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" 無名レジスタに入るデータを、*レジスタにも入れる。
set clipboard^=unnamedplus
" ターミナルモードを Vim 互換にする {{
tnoremap <C-w><S-n> <C-\><C-n>
tnoremap <C-W>n       <cmd>new<cr>
tnoremap <C-W><C-N>   <cmd>new<cr>
tnoremap <C-W>q       <cmd>quit<cr>
tnoremap <C-W><C-Q>   <cmd>quit<cr>
tnoremap <C-W>c       <cmd>close<cr>
tnoremap <C-W>o       <cmd>only<cr>
tnoremap <C-W><C-O>   <cmd>only<cr>
tnoremap <C-W><Down>  <cmd>wincmd j<cr>
tnoremap <C-W><C-J>   <cmd>wincmd j<cr>
tnoremap <C-W>j       <cmd>wincmd j<cr>
tnoremap <C-W><Up>    <cmd>wincmd k<cr>
tnoremap <C-W><C-K>   <cmd>wincmd k<cr>
tnoremap <C-W>k       <cmd>wincmd k<cr>
tnoremap <C-W><Left>  <cmd>wincmd h<cr>
tnoremap <C-W><C-H>   <cmd>wincmd h<cr>
tnoremap <C-W><BS>    <cmd>wincmd h<cr>
tnoremap <C-W>h       <cmd>wincmd h<cr>
tnoremap <C-W><Right> <cmd>wincmd l<cr>
tnoremap <C-W><C-L>   <cmd>wincmd l<cr>
tnoremap <C-W>l       <cmd>wincmd l<cr>
tnoremap <C-W>w       <cmd>wincmd w<cr>
tnoremap <C-W><C-W>   <cmd>wincmd w<cr>
tnoremap <C-W>W       <cmd>wincmd W<cr>
tnoremap <C-W>t       <cmd>wincmd t<cr>
tnoremap <C-W><C-T>   <cmd>wincmd t<cr>
tnoremap <C-W>b       <cmd>wincmd b<cr>
tnoremap <C-W><C-B>   <cmd>wincmd b<cr>
tnoremap <C-W>p       <cmd>wincmd p<cr>
tnoremap <C-W><C-P>   <cmd>wincmd p<cr>
tnoremap <C-W>P       <cmd>wincmd P<cr>
tnoremap <C-W>r       <cmd>wincmd r<cr>
tnoremap <C-W><C-R>   <cmd>wincmd r<cr>
tnoremap <C-W>R       <cmd>wincmd R<cr>
tnoremap <C-W>x       <cmd>wincmd x<cr>
tnoremap <C-W><C-X>   <cmd>wincmd x<cr>
tnoremap <C-W>K       <cmd>wincmd K<cr>
tnoremap <C-W>J       <cmd>wincmd J<cr>
tnoremap <C-W>H       <cmd>wincmd H<cr>
tnoremap <C-W>L       <cmd>wincmd L<cr>
tnoremap <C-W>T       <cmd>wincmd T<cr>
tnoremap <C-W>=       <cmd>wincmd =<cr>
tnoremap <C-W>-       <cmd>wincmd -<cr>
tnoremap <C-W>+       <cmd>wincmd +<cr>
tnoremap <C-W>z       <cmd>pclose<cr>
tnoremap <C-W><C-Z>   <cmd>pclose<cr>
" }}

" undo
set undodir=$HOME/.nvim_undo
" colorscheme
colorscheme gruvbox-material
set background=dark
let g:gruvbox_material_enable_bold=1
let g:gruvbox_material_enable_italic=1
let g:gruvbox_material_background='soft'


lua << EOL
local set = vim.keymap.set
local function show_documentation()
  local ft = vim.opt.filetype._value
  if ft == 'vim' or ft == 'help' then
    vim.cmd([[execute 'h ' . expand('<cword>') ]])
  else
    require('lspsaga.hover').render_hover_doc()
  end
end

local on_attach = function(client, bufnr)
  -- client.resolved_capabilities.document_formatting = false

  set("n", "gD", vim.lsp.buf.declaration)
  set("n", "gd", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
  set("n", "K", show_documentation)
  set("n", "<space>im", "<cmd>Telescope lsp_implementations<CR>")
  set("n", "<space>wa", vim.lsp.buf.add_workspace_folder)
  set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder)
  set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
  set("n", "<space>D", vim.lsp.buf.type_definition)
  set("n", "<F2>", require('lspsaga.rename').rename)
  set("n", "<space>ca", require('lspsaga.codeaction').code_action)
  set("n", "<space>di", "<cmd>Telescope diagnostics<CR>")
  set("n", "<space>ld", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
  set("n", "[d", require('lspsaga.diagnostic').navigate('next'))
  set("n", "]d", require('lspsaga.diagnostic').navigate('prev'))
  set("n", "<space>=", vim.lsp.buf.format)
end

local mason = require('mason')
local mason_null_ls = require('mason-null-ls')
local null_ls = require('null-ls')

mason.setup()
mason_null_ls.setup({
  ensure_installed = { 'prettier', 'dprint' },
  automatic_installation = true,
  automatic_setup = true,
})
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.dprint.with {
      condition = function(utils)
        return utils.has_file { "dprint.json", }
      end,
      extra_filetypes = { "svelte", },
    },
    null_ls.builtins.formatting.prettier.with {
      condition = function(utils)
        return utils.has_file { ".prettierrc", ".prettierrc.js", ".prettierrc.yaml" }
      end,
      prefer_local = "node_modules/.bin",
      extra_filetypes = { "svelte", },
    },
    null_ls.builtins.diagnostics.eslint.with {
      condition = function(utils)
        return utils.has_file { ".eslintrc.cjs", }
      end,
      prefer_local = "node_modules/.bin",
      extra_filetypes = { "svelte" },
    },
  },
})

require("mason-lspconfig").setup()
require('dressing').setup()
require('lspsaga').setup()

-- Set up nvim-cmp.
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-c>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      select = false,
    }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
  }, {
    { name = 'buffer' },
  }),

  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      -- before = function (entry, vim_item)
      --   ...
      --   return vim_item
      -- end
    })
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
  function (server_name)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  highlight = {
    enable = true,
  },
}

-- Telescope
local function extensions(name, prop)
  return function(opt)
    return function()
      local telescope = require "telescope"
      telescope.load_extension(name)
      return telescope.extensions[name][prop](opt or {})
    end
  end
end

require('telescope').setup {
  pickers = {
    find_files = {
      hidden = true
    },
  },
}

local builtin = require('telescope.builtin')
set('n', '<space>:',  builtin.command_history, { noremap = true, silent = true })
set('n', '<space>/',  builtin.search_history, { noremap = true, silent = true })
set('n', '<space>b',  builtin.buffers, { noremap = true, silent = true })
set('n', '<space>f',  builtin.find_files, { noremap = true, silent = true })
set('n', '<space>gf', builtin.git_files, { noremap = true, silent = true })
set('n', '<space>gc', builtin.git_commits, { noremap = true, silent = true })
set('n', '<space>gb', builtin.git_branches, { noremap = true, silent = true })
set('n', '<space>gs', builtin.git_status, { noremap = true, silent = true })
set('n', '<space>gS', builtin.git_stash, { noremap = true, silent = true })
set('n', '<space>gg', builtin.live_grep, { noremap = true, silent = true })
set('n', '<space>cs', builtin.colorscheme, { noremap = true, silent = true })
set('n', '<space>qf', builtin.quickfix, { noremap = true, silent = true })
set('n', '<space>hl', builtin.highlights, { noremap = true, silent = true })
set('n', '<space>km', builtin.keymaps, { noremap = true, silent = true })
set('n', '<space>ft', builtin.filetypes, { noremap = true, silent = true })
set('n', '<space>u',  builtin.oldfiles, { noremap = true, silent = true })
set('n', '<space>gh', extensions('ghq','list'){}, { noremap = true, silent = true })
set('n', '<space>z',  extensions('z','list'){}, { noremap = true, silent = true })

vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = { '*' },
  callback = function()
    require('lspsaga.diagnostic').show_cursor_diagnostics()
  end,
})

-- lualine
require('lualine').setup {
  options = {
    theme = 'gruvbox-material',
  },
}

-- noice
require("noice").setup()
require("telescope").load_extension("noice")

-- nvim-dap
require('dap-go').setup()
require('dap-ruby').setup()
require("dapui").setup()
require("nvim-dap-virtual-text").setup()
require("telescope").load_extension("dap")
set('n', '<F5>',       require'dap'.continue, { noremap = true, silent = true })
set('n', '<F10>',      require'dap'.step_over, { noremap = true, silent = true })
set('n', '<F11>',      require'dap'.step_into, { noremap = true, silent = true })
set('n', '<F12>',      require'dap'.step_out, { noremap = true, silent = true })
set('n', '<Leader>b',  require'dap'.toggle_breakpoint, { noremap = true, silent = true })
set('n', '<Leader>dr', require'dap'.repl.open, { noremap = true, silent = true })
set('n', '<Leader>dl', require'dap'.run_last, { noremap = true, silent = true })
set('n', '<Leader>du', require'dapui'.toggle, { noremap = true, silent = true })
EOL

