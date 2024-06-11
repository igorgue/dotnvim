vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.hl", "hypr*.conf", "monitors.conf", "workspaces.conf" },
  callback = function(event)
    vim.lsp.start({
      name = "hyprlang",
      cmd = { "hyprls" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = "hyprlang",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "hyprlang" })
      else
        opts.ensure_installed = { "hyprlang" }
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ft = "hyprlang",
    opts = {
      servers = {
        hyprls = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    ft = "hyprlang",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "hyprls" })
      end
    end,
  },
}
