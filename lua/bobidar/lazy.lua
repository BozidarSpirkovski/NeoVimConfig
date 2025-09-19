local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
	},
	{
		"rose-pine/neovim",
		name = "rose-pine", -- Optional: to simplify `colorscheme` name
		priority = 1000,     -- Ensure it's loaded before others
		config = function()
			vim.cmd("colorscheme rose-pine")  -- Load the theme
		end,
	},
	{"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
	{"nvim-treesitter/playground"},
	{"theprimeagen/harpoon"},
	{"mbbill/undotree"},
	{"tpope/vim-fugitive"},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*", -- optional but recommended
		build = "make install_jsregexp", -- optional: improves regex support
		dependencies = {
			"rafamadriz/friendly-snippets", -- optional: prebuilt snippets
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "saadparwaiz1/cmp_luasnip" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	},
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup()
		end,
		event = { "BufReadPre", "BufNewFile" }, -- optional lazy loading
	},

})


