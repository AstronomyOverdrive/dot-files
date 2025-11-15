-----------------------------------------------
-- .config/nvim/after/plugin/pluginsconf.lua --
-----------------------------------------------

-- 1. CMP
-- 2. LSP
-- 3. Telescope
-- 4. Treesitter
-- 5. Colourscheme
-- 6. vim-signify
-- 7. Live Preview

-- 1. CMP
local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-h>'] = cmp.mapping.confirm({ select = false }),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<C-l>'] = cmp.mapping.abort(),
	}),
	sources = cmp.config.sources({
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	}),
})
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- 2. LSP
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "csharp_ls", "cssls", "html", "pylsp", "ts_ls", "gopls", "phpactor", "tailwindcss", "serve_d" }
})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
vim.keymap.set('n', '<leader>re', require('telescope.builtin').lsp_references, {})
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<leader>j', '<cmd>lua vim.diagnostic.open_float()<cr>', {})
vim.lsp.enable('lua_ls')
vim.lsp.enable('csharp_ls')
vim.lsp.enable('cssls')
vim.lsp.enable('html')
vim.lsp.enable('pylsp')
vim.lsp.enable('ts_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('phpactor')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('serve_d')

-- 3. Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- 4. Treesitter
require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "javascript", "typescript", "c_sharp", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

-- 5. Colourscheme
require('onedark').setup {
	style = 'darker'
}
require('onedark').load()

-- 6. vim-signify
vim.cmd [[set updatetime=100]]
vim.cmd [[highlight SignifySignAdd guifg=#8EBD6B guibg=NONE]]
vim.cmd [[highlight SignifySignDelete guifg=#E55561 guibg=NONE]]
vim.cmd [[highlight SignifySignChange guifg=#C98E56 guibg=NONE]]
vim.cmd [[let g:signify_sign_add = '┃']]
vim.cmd [[let g:signify_sign_delete = '┃']]
vim.cmd [[let g:signify_sign_delete_first_line = '┃']]
vim.cmd [[let g:signify_sign_change = '┃']]
vim.cmd [[let g:signify_sign_change_delete = '┃']]
vim.keymap.set("n", "<leader>gd", ":SignifyHunkDiff<cr>", {})

-- 7. Live Preview
require('livepreview.config').set({
	port = 5500,
	browser = "firefox",
	dynamic_root = true,
	sync_scroll = true,
	picker = "telescope",
})
