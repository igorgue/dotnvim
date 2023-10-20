return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      lua_ls = function()
        require("lazyvim.util").lsp.on_attach(function(client, _)
          if client.name == "lua_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end)
      end,
    },
  },
}
