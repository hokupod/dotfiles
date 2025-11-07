return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    -- JS/TS
    "mxsdev/nvim-dap-vscode-js",
    {
      "microsoft/vscode-js-debug",
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
    -- Go
    "leoluz/nvim-dap-go",
    -- Lua
    "folke/neodev.nvim",
  },
  lazy = true,
  keys = {
    { "<leader>dd", "<cmd>lua require('dapui').toggle()<CR>", desc = "[Debug] Toggle Open/Close" },
    { "<leader>db", '<cmd>DapToggleBreakpoint<CR>', desc = '[Debug] Toggle Breakpoint' },
    { "<leader>dB", '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition(ex.\'x > 5\'): "), vim.fn.input("Hit condition(ex.\'5\',\'>=3\'): "), vim.fn.input("Log point message(ex.\'x is: {x}\'): "))<CR>', desc = '[Debug] Set Breakpoint with condition' },
    { "<leader>dr", '<cmd>lua require("dap").repl_open()<CR>', desc = '[Debug] Open REPL' },
    { "<leader>dp", '<cmd>lua require("dap.ui.widgets").repl_open()<CR>', desc = '[Debug] Open REPL' },
    { "<leader>dR", '<cmd>lua require("dap").run_last()<CR>', desc = '[Debug] Run last' },
    { '<F5>', '<cmd>lua require("dap").continue()<CR>', desc = '[Debug] Continue' },
    { '<F10>', '<cmd>DapStepOver<CR>', desc = '[Debug] Step Over' },
    { '<F11>', '<cmd>DapStepInto<CR>', desc = '[Debug] Step Into' },
    { '<F12>', '<cmd>DapStepOut<CR>', desc = '[Debug] Step Out' },
    { "<leader>de", '<cmd>lua require("dapui").eval()<CR>', desc = "[Debug] Eval", mode = "v" },
  },
  config = function()
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

    local continue = function()
      if vim.fn.filereadable('.vscode/launch.json') then
        require('dap.ext.vscode').load_launchjs(nil, debugger_table)
      end
      require('dap').continue()
    end

    -- Update the F5 mapping to use the continue function
    vim.keymap.set('n', '<F5>', continue, { noremap = true, silent = true, desc = '[Debug] Continue' })
  end,
}
