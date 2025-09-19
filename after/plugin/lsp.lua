local lsp = require("lsp-zero")

lsp.preset("recommended")

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "vtsls",
    "lua_ls",
    "intelephense",
    "volar",
    "tsserver",
  },
  handlers = {
    function(server_name)
      require("lsp-zero").default_setup(server_name)
    end,

    ["vtsls"] = function()
      require("lspconfig").vtsls.setup({
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        init_options = {
          vue = {
            hybridMode = true,  -- true if you're using <script setup> and script
          },
          typescript = {
            tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"
          }
        }
      })
    end,

  ["volar"] = function()
    require("lspconfig").volar.setup({
      filetypes = { "vue" },
      init_options = {
        vue = {
          hybridMode = true,
        },
      },
    })
  end,

  ["tsserver"] = function()
    local mason_registry = require("mason-registry")
    local volar_pkg = mason_registry.get_package("volar")
    local volar_path = volar_pkg:get_install_path()

    require("lspconfig").tsserver.setup({
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = volar_path, -- dynamically use Mason path
            languages = { "vue" },
          },
        },
      },
      filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
      },
      on_attach = require("lsp-zero").get_on_attach(),
      capabilities = require("lsp-zero").get_capabilities(),
    })
  end,
  },
})


local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_next_item(),
    ["<C-o>"] = cmp.mapping.select_prev_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})
lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

