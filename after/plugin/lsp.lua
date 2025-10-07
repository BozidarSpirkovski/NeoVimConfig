----------------------------------------------------------------------
-- 1. Mason: installs external LSP binaries
----------------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "intelephense",
    "vtsls",
    -- install vue-language-server manually: :MasonInstall vue-language-server
  },
  automatic_installation = true,
})

----------------------------------------------------------------------
-- 2. Capabilities for completion
----------------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

----------------------------------------------------------------------
-- 3. nvim-cmp  +  LuaSnip
----------------------------------------------------------------------
local cmp     = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"]     = cmp.mapping.select_prev_item(),
    ["<C-n>"]     = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-y>"]     = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer"  },
    { name = "path"    },
  }),
})

----------------------------------------------------------------------
-- 4. Common on-attach → buffer-local keymaps
----------------------------------------------------------------------
local function setup_lsp_keymaps(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd",         vim.lsp.buf.definition,        "LSP: Go to definition of symbol under cursor")
  map("n", "K",          vim.lsp.buf.hover,             "LSP: Show documentation / hover info")
  map("n", "<leader>vws",vim.lsp.buf.workspace_symbol,  "LSP: Search symbols across entire workspace")
  map("n", "<leader>vd", vim.diagnostic.open_float,     "Diagnostics: Show warning/error for current line")
  map("n", "[d",         vim.diagnostic.goto_prev,      "Diagnostics: Jump to previous diagnostic")
  map("n", "]d",         vim.diagnostic.goto_next,      "Diagnostics: Jump to next diagnostic")
  map("n", "<leader>vca",vim.lsp.buf.code_action,       "LSP: Show available code actions / quick fixes")
  map("n", "<leader>vrr",vim.lsp.buf.references,        "LSP: List all references to symbol under cursor")
  map("n", "<leader>vrn",vim.lsp.buf.rename,            "LSP: Rename all references of current symbol")
  map("i", "<C-h>",      vim.lsp.buf.signature_help,    "LSP: Show function signature while typing")
  map("n", "<leader>ef", "<cmd>EslintFixAll<CR>",       "ESLint: Fix all auto-fixable problems")
end

----------------------------------------------------------------------
-- 5.  Configure every server with  vim.lsp.config()
--     (native API — no lspconfig)
----------------------------------------------------------------------

-- Lua
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  on_attach    = setup_lsp_keymaps,
})

-- PHP
vim.lsp.config("intelephense", {
  capabilities = capabilities,
  on_attach    = setup_lsp_keymaps,
})

-- TypeScript / JavaScript
vim.lsp.config("vtsls", {
  capabilities = capabilities,
  on_attach    = setup_lsp_keymaps,
  filetypes    = { "typescript","javascript","typescriptreact","javascriptreact","vue" },
  init_options = {
    vue = { hybridMode = true },
    typescript = {
      tsdk = vim.fn.stdpath("data")
              .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
    },
  },
})

-- Vue / Volar
vim.lsp.config("volar", {
  capabilities = capabilities,
  on_attach    = setup_lsp_keymaps,
  filetypes    = { "vue" },
  init_options = {
    vue = { hybridMode = true },
  },
})

-- ESLint
vim.lsp.config("eslint", {
  capabilities = capabilities,
  on_attach    = setup_lsp_keymaps,
})

vim.lsp.enable({
  "lua_ls",
  "intelephense",
  "vtsls",
  "volar",
  "eslint",
})
