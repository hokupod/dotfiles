require("nvim-dap-virtual-text").setup({})
require("dap-go").setup()
require("dapui").setup()
require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end

require("dap-vscode-js").setup({
  debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
})

local languages = { "typescript", "javascript", "typescriptreact", "svelte" }
local debugger_table = { ['pwa-node'] = languages }

local continue = function()
  if vim.fn.filereadable('.vscode/launch.json') then
    require('dap.ext.vscode').load_launchjs(nil, debugger_table)
  end
  require('dap').continue()
end

local set_conditional_breakpoint = function()
  local condition = vim.fn.input("Breakpoint condition(ex.'x > 5'): ")
  local hit_condition = vim.fn.input("Hit condition(ex.'5','>=3'): ")
  local log_message = vim.fn.input("Log point message(ex.'x is: {x}'): ")
  dap.set_breakpoint(condition, hit_condition, log_message)
end

local wk = require("which-key")
wk.register({
  d = {
    name = "Debug",
    d = { "<cmd>lua require('dapui').toggle()<CR>", "[Debug] Toggle Open/Close" },
    b = { '<cmd>DapToggleBreakpoint<CR>', '[Debug] Toggle Breakpoint' },
    B = { set_conditional_breakpoint, '[Debug] Set Breakpoint with condition' },
    r = { '<cmd>lua require("dap").repl_open()<CR>', '[Debug] Open REPL' },
    p = { '<cmd>lua require("dap.ui.widgets").repl_open()<CR>', '[Debug] Open REPL' },
    R = { '<cmd>lua require("dap").run_last()<CR>', '[Debug] Run last' },
  },
}, {
  mode = "n",
  prefix = "<leader>",
})
vim.keymap.set('n', '<F5>', continue, { noremap = true, silent = true, desc = '[Debug] Continue' })
vim.keymap.set('n', '<F10>', '<cmd>DapStepOver<CR>', { noremap = true, silent = true, desc = '[Debug] Step Over' })
vim.keymap.set('n', '<F11>', '<cmd>DapStepInto<CR>', { noremap = true, silent = true, desc = '[Debug] Step Into' })
vim.keymap.set('n', '<F12>', '<cmd>DapStepOut<CR>', { noremap = true, silent = true, desc = '[Debug] Step Out' })

wk.register({
  d = {
    name = "Debug",
    e = { '<cmd>lua require("dapui").eval()<CR>', '[Debug] Eval' },
  }
}, {
  mode = "v",
  prefix = "<leader>",
})

