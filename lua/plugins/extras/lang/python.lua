return {
  {
    "neovim/nvim-lspconfig",
    ft = "python",
    opts = {
      servers = {
        pyright = {
          on_attach = function(client, _)
            client.server_capabilities.codeActionProvider = false
          end,
          capabilities = (function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return capabilities
          end)(),
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff_lsp = {
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
}
