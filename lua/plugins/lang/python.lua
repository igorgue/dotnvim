return {
  {
    "neovim/nvim-lspconfig",
    ft = "python",
    opts = {
      servers = {
        pyright = {
          settings = {
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
      },
    },
  },
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
}
