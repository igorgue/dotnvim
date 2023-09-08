local utils = require("utils")

return {
  {
    "czheo/mojo.vim",
    ft = { "mojo" },
    init = function()
      -- NOTE: support for format after save, replace with null-ls when working
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.🔥", "*.mojo" },
        callback = function()
          vim.cmd("silent! !mojo format --quiet " .. vim.fn.expand("%"))
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mojo",
        callback = function()
          local modular = vim.env.MODULAR_HOME
          local lsp_cmd = modular .. "/pkg/packages.modular.com_mojo/bin/mojo-lsp-server"

          vim.bo.expandtab = true
          vim.bo.shiftwidth = 4
          vim.bo.softtabstop = 4

          vim.lsp.start({
            name = "mojo-lsp-server",
            cmd = { lsp_cmd },
          })
        end,
      })
    end,
  },
  -- TODO: Make this work
  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   opts = function(_, opts)
  --     local h = require("null-ls.helpers")
  --     local methods = require("null-ls.methods")
  --
  --     local FORMATTING = methods.internal.FORMATTING
  --
  --     local mojo_fmt = h.make_builtin({
  --       name = "mojo",
  --       meta = {
  --         url = "https://github.com/modularml/mojo",
  --         description = "The Mojo Programming Language formatter",
  --       },
  --       method = FORMATTING,
  --       filetypes = { "mojo" },
  --       generator_opts = {
  --         command = "mojo",
  --         args = {
  --           "format",
  --           "--quiet",
  --           "$FILENAME",
  --         },
  --         format = nil,
  --       },
  --       factory = h.formatter_factory,
  --     })
  --
  --     vim.list_extend(opts.sources, { mojo_fmt })
  --   end,
  -- },
}
