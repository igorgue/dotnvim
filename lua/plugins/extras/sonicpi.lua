local function get_server_path()
  local exepath = vim.fn.exepath("sonic-pi")
  ---@diagnostic disable-next-line: undefined-field
  local realpath = vim.loop.fs_realpath(exepath)
  local pkg_root = vim.fn.fnamemodify(realpath, ":h:h")
  return pkg_root .. "/app/server"
end

local server_path = get_server_path()

require("lazyvim.util").lsp.on_attach(function(client, _)
  if client.name == "solargraph" then
    require("sonicpi").lsp_on_init(client, { server_dir = server_path })
  end
end)

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.sonicpi" },
  callback = function()
    if require("sonicpi.opts").remote.lifecycle.daemon_started == 1 then
      vim.cmd("SonicPiSendBuffer")
    end
  end,
})

return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "magicmonty/sonicpi.nvim",
    },
    opts = {
      sources = {
        default = { "sonicpi" },
        providers = {
          sonicpi = {
            name = "sonicpi",
            module = "blink.compat.source",
            opts = {},
          },
        },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    ft = "sonicpi",
    config = function()
      require("luasnip").filetype_extend("sonicpi", { "ruby" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "sonicpi" },
    optional = true,
    opts = function(_, opts)
      vim.treesitter.language.register("ruby", "sonicpi")

      opts.indent = {
        enable = true,
        disable = false,
      }
      opts.highlight.additional_vim_regex_highlighting = true

      return opts
    end,
  },
  {
    "stevearc/conform.nvim",
    ft = { "sonicpi" },
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
        ruby_lsp = {
          filetypes = { "ruby", "sonicpi" },
          single_file_support = true,
        },
        solargraph = {
          enabled = true,
          filetypes = { "ruby", "sonicpi" },
          diagnostics = true,
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
    ft = { "sonicpi" },
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      local wk = require("which-key")

      local mappings = {
        { "n", "<M-s>", require("sonicpi.remote").stop, { desc = "Sonic Pi Stop" } },
        { "i", "<M-s>", require("sonicpi.remote").stop, { desc = "Sonic Pi Stop" } },
        { "n", "<M-r>", require("sonicpi.remote").run_current_buffer, { desc = "Sonic Pi Run" } },
        { "i", "<M-r>", require("sonicpi.remote").run_current_buffer, { desc = "Sonic Pi Run" } },
      }
      opts = vim.tbl_extend("force", opts, { mappings = mappings })

      require("sonicpi").setup(opts)

      wk.add({
        { "<leader>S", group = "sonicpi", icon = { icon = " ", color = "cyan" } },
      })
    end,
    opts = {
      server_dir = server_path,
      single_file = true,
      lsp_diagnostics = true,
    },
    keys = {
      { "<cr>", "<cmd>SonicPiSendBuffer<CR>", desc = "Sonic Pi send buffer", ft = "sonicpi" },
      {
        "<s-cr>",
        function()
          require("sonicpi.remote").stop()
        end,
        desc = "Sonic Pi stop clock",
        ft = "sonicpi",
      },
      { "<leader>Ss", "<cmd>SonicPiStartDaemon<CR>", desc = "Sonic Pi start daemon", ft = "sonicpi" },
      { "<leader>SS", "<cmd>SonicPiStopDaemon<CR>", desc = "Sonic Pi stop daemon", ft = "sonicpi" },
      {
        "<leader>;",
        function()
          require("sonicpi.remote").stop()
          require("sonicpi.remote").run_current_buffer()
        end,
        desc = "Sonic Pi restart clock",
        ft = "sonicpi",
      },
    },
  },
}
