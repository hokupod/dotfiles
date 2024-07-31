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
wk.add({
  { "<leader>d", group = "Debug" },
  { "<leader>dd", "<cmd>lua require('dapui').toggle()<CR>", desc = "[Debug] Toggle Open/Close" },
  { "<leader>db", '<cmd>DapToggleBreakpoint<CR>', desc = '[Debug] Toggle Breakpoint' },
  { "<leader>dB", set_conditional_breakpoint, desc = '[Debug] Set Breakpoint with condition' },
  { "<leader>dr" ,'<cmd>lua require("dap").repl_open()<CR>', desc = '[Debug] Open REPL' },
  { "<leader>dp" ,'<cmd>lua require("dap.ui.widgets").repl_open()<CR>', desc = '[Debug] Open REPL' },
  { "<leader>dR" ,'<cmd>lua require("dap").run_last()<CR>', desc = '[Debug] Run last' },
})
vim.keymap.set('n', '<F5>', continue, { noremap = true, silent = true, desc = '[Debug] Continue' })
vim.keymap.set('n', '<F10>', '<cmd>DapStepOver<CR>', { noremap = true, silent = true, desc = '[Debug] Step Over' })
vim.keymap.set('n', '<F11>', '<cmd>DapStepInto<CR>', { noremap = true, silent = true, desc = '[Debug] Step Into' })
vim.keymap.set('n', '<F12>', '<cmd>DapStepOut<CR>', { noremap = true, silent = true, desc = '[Debug] Step Out' })

wk.add({
  { "<leader>d", group = "Debug", mode = "v" },
  { "<leader>de", '<cmd>lua require("dapui").eval()<CR>', desc = "[Debug] Eval", mode = "v" },
})

