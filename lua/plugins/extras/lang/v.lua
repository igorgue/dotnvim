return {
  -- FIXME: LSP not working
  -- {
  --   "neovim/nvim-lspconfig",
  --   ft = { "vlang" },
  --   opts = function(_, opts)
  --     -- stylua: ignore
  --     if vim.fn.executable("v") ~= 1 then return end
  --
  --     -- stylua: ignore
  --     pcall(function() vim.cmd("silent !v ls --install") end)
  --
  --     opts.servers = {
  --       vls = {},
  --     }
  --   end,
  -- },
  {
    "ollykel/v-vim",
    event = {
      "BufReadPre *.v",
      "BufReadPre *.vv",
      "BufReadPre *.vsh",
      "BufNewFile *.v",
      "BufNewFile *.vv",
      "BufNewFile *.vsh",
    },
    init = function()
      vim.g.v_autofmt_bufwritepre = true
    end,
  },
}
