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
	{
		"folke/which-key.nvim",
		event = "VeryLazy",      -- load after startup
		config = function()
			local wk = require("which-key")
			wk.setup({
				plugins = { spelling = { enabled = true } },
				window  = { border = "rounded", position = "bottom" },
			})

			-- Optional grouping
			-- wk.register({
			-- 	["<leader>v"] = { name = "+LSP" },
			-- 	["<leader>p"] = { name = "+Telescope" },
			-- 	["<leader>e"] = { name = "+ESLint" },
			-- })
		end,
	},

})


