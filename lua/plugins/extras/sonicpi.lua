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
      local mappings = {
        { "n", "<leader>S", require("sonicpi.remote").stop, { desc = "Sonic Pi Stop" } },
        { "i", "<M-s>", require("sonicpi.remote").stop, { desc = "Sonic Pi Stop" } },
        { "n", "<leader>r", require("sonicpi.remote").run_current_buffer, { desc = "Sonic Pi Run" } },
        { "n", "<M-r>", require("sonicpi.remote").run_current_buffer, { desc = "Sonic Pi Run" } },
        { "i", "<M-r>", require("sonicpi.remote").run_current_buffer, { desc = "Sonic Pi Run" } },
      }
      opts = vim.tbl_extend("force", opts, { mappings = mappings })

      require("sonicpi").setup(opts)
      require("luasnip").filetype_extend("sonicpi", { "ruby" })
    end,
    opts = {
      server_dir = server_path,
      single_file = true,
      lsp_diagnostics = true,
    },
    keys = {
      { "<c-p>", "<cmd>SonicPiSendBuffer<CR>", desc = "Sonic Pi send buffer", ft = "sonicpi" },
      {
        "<c-s-p>",
        function()
          require("sonicpi.remote").stop()
        end,
        desc = "Sonic Pi stop clock",
        ft = "sonicpi",
      },
      { "<leader>;", "<cmd>SonicPiStartDaemon<CR>", desc = "Sonic Pi start daemon", ft = "sonicpi" },
      { "<leader>,", "<cmd>SonicPiStopDaemon<CR>", desc = "Sonic Pi stop daemon", ft = "sonicpi" },
      {
        "<leader>.",
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
