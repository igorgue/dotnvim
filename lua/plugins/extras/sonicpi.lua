vim.g.lazyvim_ruby_lsp = "solargraph"

local exepath = vim.fn.exepath("sonic-pi")
---@diagnostic disable-next-line: undefined-field
local realpath = vim.loop.fs_realpath(exepath)
local pkg_root = vim.fn.fnamemodify(realpath, ":h:h")
local server_path = pkg_root .. "/app/server"

require("lazyvim.util").lsp.on_attach(function(client, _)
  if client.name == "solargraph" then
    require("sonicpi").lsp_on_init(client, { server_dir = server_path })
  end
end)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "sonicpi" },
    opts = function(_, opts)
      vim.treesitter.language.register("ruby", "sonicpi")

      opts.indent = {
        enable = true,
        disable = { "sonicpi" },
      }
      opts.highlight.additional_vim_regex_highlighting = true

      return opts
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sonicpi = { "rubocop" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {
          enabled = true,
          filetypes = { "ruby", "sonicpi" },
          diagnostics = true,
          single_file = true,
          single_file_support = true,
        },
        rubocop = {
          enabled = true,
          filetypes = { "ruby", "sonicpi" },
          single_file_support = true,
        },
      },
    },
  },
  {
    "magicmonty/sonicpi.nvim",
    -- dir = "~/Code/sonicpi.nvim",
    lazy = false,
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      local wk = require("which-key")

      wk.add({
        { "<leader>S", group = "Sonic Pi" },
      })

      local mappings = {
        { "n", "<leader>S", require("sonicpi.remote").stop, { desc = "Sonic Pi Stop" } },
        { "i", "<M-s>", require("sonicpi.remote").stop, { desc = "Sonic Pi Stop" } },
        { "n", "<leader>r", require("sonicpi.remote").run_current_buffer, { desc = "Sonic Pi Run" } },
        { "n", "<M-r>", require("sonicpi.remote").run_current_buffer, { desc = "Sonic Pi Run" } },
        { "i", "<M-r>", require("sonicpi.remote").run_current_buffer, { desc = "Sonic Pi Run" } },
      }
      opts = vim.tbl_extend("force", opts, { mappings = mappings })

      require("sonicpi").setup(opts)
    end,
    opts = {
      server_dir = server_path,
      single_file = true,
      lsp_diagnostics = true,
    },
  },
}
