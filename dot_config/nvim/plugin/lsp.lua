require("fidget").setup({})
require("aerial").setup({
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
		vim.keymap.set("n", "+", "<cmd>AerialToggle!<CR>", { buffer = bufnr })
	end,
})

local set = vim.keymap.set
local function show_documentation()
	local ft = vim.opt.filetype._value
	if ft == "vim" or ft == "help" then
		vim.cmd([[execute 'h ' . expand('<cword>') ]])
	else
		vim.cmd([[Lspsaga hover_doc]])
	end
end
local on_attach = function(client, bufnr)
	-- Keybind
	set("n", "K", show_documentation)
	set("n", "<F2>", "<cmd>Lspsaga rename<CR>")

	local wk = require("which-key")
	wk.register({
		l = {
			name = "LSP",
			["f"] = { "<cmd>lua vim.lsp.buf.format()<CR>", "[LSP] Format" },
			["<F2>"] = { "<cmd>Lspsaga rename<CR>", "[LSP] Rename" },
			g = {
				name = "+go",
				d = { "<cmd>Lspsaga goto_definition<CR>", "[LSP] Definition" },
				i = { "<cmd>Telescope lsp_implementations<CR>", "[LSP] Implementations" },
				t = { "<cmd>Lspsaga goto_type_definition<CR>", "[LSP] Type definition" },
				n = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "[LSP] Diagnostics next" },
				p = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "[LSP] Diagnostics prev" },
			},
			s = {
				name = "+show",
				d = { "<cmd>Telescope diagnostics<CR>", "[LSP] Telescope diagnostics" },
				l = { "<cmd>Lspsaga show_line_diagnostics<CR>", "[LSP] Line diagnostics" },
				c = { require("actions-preview").code_actions, "[LSP] Code action" },
				o = { "<cmd>Lspsaga outline<CR>", "[LSP] outline" },
			},
			w = {
				name = "+workspace",
				a = { "<cmd>vim.lsp.buf.add_workspace_folder<CR>", "[LSP] Add workspace dir" },
				r = { "<cmd>vim.lsp.buf.remove_workspace_folder<CR>", "[LSP] Remove workspace dir" },
				l = {
					"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
					"[LSP] List workspace dir",
				},
			},
		},
	}, {
		mode = "n",
		prefix = "<leader>",
	})

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end
end

local mason = require("mason")
mason.setup()

require("mason-lspconfig").setup()
require("lspsaga").setup({
	outline = {
		layout = "float",
	},
})
-- Set up nvim-cmp.
local cmp = require("cmp")
local lspkind = require("lspkind")

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

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
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-c>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({
			select = false,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lua" },
	}, {
		{ name = "buffer" },
	}),

	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			symbol_map = { Codeium = "" },

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			-- before = function (entry, vim_item)
			--   ...
			--   return vim_item
			-- end
		}),
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
})

local lspconfig = require("lspconfig")

lspconfig["tsserver"].setup({
	on_attach = function(client, _)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
})

-- -- formatter
-- local js_formatters = {
-- 	{
-- 		"biome",
-- 		-- "prettierd",
-- 		-- "prettier",
-- 	},
-- }
-- require("conform").setup({
-- 	formatters_by_ft = {
-- 		lua = { "stylua" },
-- 		html = js_formatters,
-- 		css = js_formatters,
-- 		json = js_formatters,
-- 		yaml = js_formatters,
-- 		javascript = js_formatters,
-- 		typescript = js_formatters,
-- 		javascriptreact = js_formatters,
-- 		typescriptreact = js_formatters,
-- 		astro = js_formatters,
-- 		svelte = js_formatters,
-- 		go = { "goimports" },
-- 	},
-- 	format_on_save = {
-- 		-- These options will be passed to conform.format()
-- 		timeout_ms = 500,
-- 		lsp_fallback = true,
-- 		async = false,
-- 	},
-- })

-- linter
local js_linters = {
	-- "eslint",
	"biomejs",
	-- "eslint_d",
}
local lint = require("lint")
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

lint.linters_by_ft = {
	javascript = js_linters,
	typescript = js_linters,
	javascriptreact = js_linters,
	typescriptreact = js_linters,
	astro = js_linters,
	svelte = js_linters,
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint(nil, {
			ignore_errors = true,
		})
	end,
})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				pathStrict = true,
				path = { "?.lua", "?/init.lua" },
			},
			workspace = {
				library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
					"${3rd}/luv/library",
					-- "${3rd}/busted/library",
					-- "${3rd}/luassert/library",
				}),
				checkThirdParty = "Disable",
			},
		},
	},
})
