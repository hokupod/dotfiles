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

local function set_conditional_breakpoint()
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
    p = { '<cmd>lua require("dap.ui.widgets").preview()<CR>', '[Debug] Preview' },
    R = { '<cmd>lua require("dap").run_last()<CR>', '[Debug] Run last' },
    ['<F5>'] = { '<cmd>DapContinue<CR>', '[Debug] Continue' },
    ['<F10>'] = { '<cmd>DapStepOver<CR>', '[Debug] Step Over' },
    ['<F11>'] = { '<cmd>DapStepInto<CR>', '[Debug] Step Into' },
    ['<F12>'] = { '<cmd>DapStepOut<CR>', '[Debug] Step Out' },
  }
}, {
  mode = "n",
  prefix = "<leader>",
})

wk.register({
  d = {
    name = "Debug",
    e = { '<cmd>lua require("dapui").eval()<CR>', '[Debug] Eval' },
  }
}, {
  mode = "v",
  prefix = "<leader>",
})

