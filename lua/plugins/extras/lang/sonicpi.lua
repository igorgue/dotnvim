local function get_server_path()
  local exepath = vim.fn.exepath("sonic-pi")
  ---@diagnostic disable-next-line: undefined-field
  local realpath = vim.loop.fs_realpath(exepath)
  local pkg_root = vim.fn.fnamemodify(realpath, ":h:h")

  return pkg_root .. "/app/server"
end

local server_path = get_server_path()

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.sonicpi" },
  callback = function()
    vim.cmd("SonicPiSendBuffer")
  end,
})

return {
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "magicmonty/sonicpi.nvim" },
    opts = {
      sources = {
        compat = { "sonicpi" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    ft = { "sonicpi" },
    optional = true,
    opts = function(_, opts)
      vim.treesitter.language.register("ruby", "sonicpi")

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
      setup = {
        -- stylua: ignore
        ruby_lsp = function() return true end,
      },
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
    init = function()
      require("snacks").util.lsp.on(function(buf, client)
        if client.name == "ruby_lsp" then
          require("sonicpi").lsp_on_init(client, { server_dir = server_path })
        end
      end)
    end,
  },
  {
    "magicmonty/sonicpi.nvim",
    ft = { "sonicpi" },
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      local wk = require("which-key")

      local mappings = {
        {
          "n",
          "<M-s>",
          require("sonicpi.remote").stop,
          { desc = "Sonic Pi Stop" },
        },
        {
          "i",
          "<M-s>",
          require("sonicpi.remote").stop,
          { desc = "Sonic Pi Stop" },
        },
        {
          "n",
          "<M-r>",
          require("sonicpi.remote").run_current_buffer,
          { desc = "Sonic Pi Run" },
        },
        {
          "i",
          "<M-r>",
          require("sonicpi.remote").run_current_buffer,
          { desc = "Sonic Pi Run" },
        },
      }
      opts = vim.tbl_extend("force", opts, { mappings = mappings })

      require("sonicpi").setup(opts)

      wk.add({
        {
          "<leader>;",
          group = "sonicpi",
          icon = { icon = " ", color = "pink" },
        },
      })
    end,
    opts = {
      server_dir = server_path,
      single_file = true,
      lsp_diagnostics = true,
    },
    keys = {
      {
        "<leader>;;",
        "<cmd>SonicPiStartDaemon<cr>",
        ft = "sonicpi",
      },
      {
        "<leader>;:",
        "<cmd>SonicPiStopDaemon<cr>",
        ft = "sonicpi",
      },
      {
        "<leader>;l",
        "<cmd>SonicPiShowLogs<cr>",
        ft = "sonicpi",
      },
      {
        "<leader>;h",
        "<cmd>SonicPiHideLogs<cr>",
        ft = "sonicpi",
      },
      {
        "<cr>",
        "<cmd>SonicPiSendBuffer<CR>",
        desc = "Sonic Pi send buffer",
        ft = "sonicpi",
      },
      {
        "<s-cr>",
        function()
          require("sonicpi.remote").stop()
        end,
        desc = "Sonic Pi stop clock",
        ft = "sonicpi",
      },
      {
        "<leader>;r",
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
