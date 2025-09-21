---------------------------
-- .config/nvim/init.lua --
---------------------------

-- Visual
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false
vim.opt.colorcolumn = "81"

-- Indenting
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = -1
vim.opt.expandtab = false

-- Leader
vim.g.mapleader = " "

-- Copy and paste
vim.keymap.set('n', '<C-c>', '"+yy')
vim.keymap.set('i', '<C-c>', '<Esc>"+yya')
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('n', '<C-p>', '"+p')
vim.keymap.set('i', '<C-p>', '<Esc>"+pa')
vim.keymap.set('v', '<C-p>', 'd"+p')

-- Search
vim.opt.wrapscan = false
vim.keymap.set('n', '<leader>hh', ':noh<cr>')

-- Unbind command history
vim.keymap.set('n', 'q:', '')
vim.keymap.set('n', 'Q', '')

-- Tabs and buffers
vim.keymap.set('n', '<leader>n', ':tabnew<cr>')
vim.keymap.set('n', '<leader>q', ':bd<cr>')
vim.keymap.set('n', '<leader>tq', ':bd!<cr>')
vim.keymap.set('n', '<leader>1', ':tabn1<cr>')
vim.keymap.set('n', '<leader>2', ':tabn2<cr>')
vim.keymap.set('n', '<leader>3', ':tabn3<cr>')
vim.keymap.set('n', '<leader>4', ':tabn4<cr>')
vim.keymap.set('n', '<leader>5', ':tabn5<cr>')
vim.keymap.set('n', '<leader>6', ':tabn6<cr>')
vim.keymap.set('n', '<leader>7', ':tabn7<cr>')
vim.keymap.set('n', '<leader>8', ':tabn8<cr>')
vim.keymap.set('n', '<leader>9', ':tabn9<cr>')
vim.keymap.set('n', '<leader>0', ':tabn10<cr>')

-- Snippets
vim.keymap.set('n', '<leader>html',
	'i<!DOCTYPE html><cr><html lang="en"><cr><head><cr><meta charset="UTF-8"><cr><meta name="viewport" content="width=device-width, initial-scale=1"><cr><title>Webpage</title><cr><link rel="icon" href="assets/images/favicon.png"><cr><link href="style/main.css" rel="stylesheet"><cr><script src="scripts/main.js" defer></script><cr><BS></head><cr><body><cr><header><cr></header><cr><cr><main><cr></main><cr><cr><footer><cr></footer><cr><cr><script><cr>// Inline script<cr><BS></script><cr><BS></body><cr><BS></html><Esc>gg')

-- Terminal
vim.keymap.set('n', '<leader>t', ':tabnew<cr>:terminal<cr>i')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-q>', '<C-\\><C-n>:bd!<cr>')

-- File explorer
vim.keymap.set('n', '<leader>fs', ':Explore<cr>')

-- Strip trailing whitespace and format
vim.api.nvim_create_user_command(
	"W",
	function()
		vim.cmd [[:silent! lua vim.lsp.buf.format()]]
		vim.cmd [[:silent! %s/ \+\n/\r/g]]
		vim.cmd [[:silent! %s/\t\+\n/\r/g]]
		vim.cmd [[:w]]
	end,
	{}
)

-- Papyrus syntax highlighting
vim.api.nvim_create_autocmd({ "VimEnter", "BufAdd" }, {
	pattern = { "*.psc" },
	callback = function()
		vim.cmd [[call matchadd('Number', '[A-Za-z0-9]')]]
		vim.cmd [[call matchadd('Function', '\<0\>\|\<1\>\|\<2\>\|\<3\>\|\<4\>\|\<5\>\|\<6\>\|\<7\>\|\<8\>\|\<9\>')]]
		vim.cmd [[call matchadd('Constant', '\.[A-Za-z]\+')]]
		vim.cmd [[call matchadd('Constant', '[A-Za-z]\+(')]]
		vim.cmd [[call matchadd('Normal', '[^A-Za-z0-9]\+')]]
		vim.cmd [[call matchadd('Function', '\<scriptname\>\|\<extends\>\|\<return\>\|\<global\>\|\<hidden\>\|\<event\>\|\<function\>\|\<if\>\|\<else\>\|\<elseif\>\|\<endevent\>\|\<endfunction\>\|\<endif\>\|\<true\>\|\<false\>\|\<import\>\|\<property\>\c')]]
		vim.cmd [[call matchadd('Statement', '\<bool\>\|\<int\>\|\<float\>\|\<string\>\|\<actor\>\|\<form\>\|\<utility\>\|\<objectreference\>\|\<projectile\>\|\<auto\>\c')]]
		vim.cmd [[call matchadd('string', '".\+"')]]
		vim.cmd [[call matchadd('Comment', ';.\+\n')]]
	end
})

-- Package Manager
local function bootstrap_pckr()
	local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
	if not (vim.uv or vim.loop).fs_stat(pckr_path) then
		vim.fn.system({
			'git',
			'clone',
			"--filter=blob:none",
			'https://github.com/lewis6991/pckr.nvim',
			pckr_path
		})
	end
	vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add {
	-- CMP
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-vsnip',
	'hrsh7th/vim-vsnip',
	'rafamadriz/friendly-snippets',
	-- LSP
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
	'neovim/nvim-lspconfig',
	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		requires = { 'nvim-lua/plenary.nvim' }
	},
	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	},
	-- Colourscheme
	'navarasu/onedark.nvim',
	-- vim-signify
	'mhinz/vim-signify',
	-- Live Preview
	'brianhuster/live-preview.nvim',
}
