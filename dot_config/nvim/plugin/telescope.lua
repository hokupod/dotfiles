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
  defaults = {
    mappings = {
    },
  },
  pickers = {
    find_files = {
      hidden = true
    },
    live_grep = {
      additional_args = function(opts)
        return { "--hidden" }
      end
    }
  },
}

local builtin = require('telescope.builtin')
local set = vim.keymap.set
set('n', '<space>:', builtin.command_history, { noremap = true, silent = true, desc = "[Telescope] command_history" })
set('n', '<space>/', builtin.search_history, { noremap = true, silent = true, desc = "[Telescope] search_history" })
set('n', '<space>b', builtin.buffers, { noremap = true, silent = true, desc = "[Telescope] buffers" })
set('n', '<space>f', builtin.find_files, { noremap = true, silent = true, desc = "[Telescope] find_files" })
set('n', '<space>gf', builtin.git_files, { noremap = true, silent = true, desc = "[Telescope] git_files" })
set('n', '<space>gc', builtin.git_commits, { noremap = true, silent = true, desc = "[Telescope] git_commits" })
set('n', '<space>gb', builtin.git_branches, { noremap = true, silent = true, desc = "[Telescope] git_branches" })
set('n', '<space>gs', builtin.git_status, { noremap = true, silent = true, desc = "[Telescope] git_status" })
set('n', '<space>gS', builtin.git_stash, { noremap = true, silent = true, desc = "[Telescope] git_status" })
set('n', '<space>gg', builtin.live_grep, { noremap = true, silent = true, desc = "[Telescope] live_grep" })
set('n', '<space>cs', builtin.colorscheme, { noremap = true, silent = true, desc = "[Telescope] colorscheme" })
set('n', '<space>qf', builtin.quickfix, { noremap = true, silent = true, desc = "[Telescope] quickfix" })
set('n', '<space>hl', builtin.highlights, { noremap = true, silent = true, desc = "[Telescope] highlights" })
set('n', '<space>km', builtin.keymaps, { noremap = true, silent = true, desc = "[Telescope] keymaps" })
set('n', '<space>ft', builtin.filetypes, { noremap = true, silent = true, desc = "[Telescope] filetypes" })
set('n', '<space>u', builtin.oldfiles, { noremap = true, silent = true, desc = "[Telescope] oldfiles" })
set('n', '<space>gh', extensions('ghq', 'list') {}, { noremap = true, silent = true, desc = "[Telescope] ghq" })
set('n', '<space>z', extensions('z', 'list') {}, { noremap = true, silent = true, desc = "[Telescope] z" })
