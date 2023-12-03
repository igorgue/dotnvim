return {
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    lazy = false, -- TODO: Figure out why this cannot lazy load...
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = true
    end,
    cmd = { "MoltenInit" },
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Molten init" },
      { "<leader>mR", "<cmd>MoltenRestart<cr>", desc = "Molten restart" },
      { "<leader>mO", "<cmd>MoltenEvaluateOperator<cr>", desc = "Molten evaluate operator" },
      { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten evaluate line" },
      { "<leader>mc", "<cmd>MoltenReevaluateCell<cr>", desc = "Molten re-evaluate cell" },
      { "<leader>mr", ":<C-u>MoltenEvaluateVisual<cr>", desc = "Molten evaluate visual", mode = "x" },
      { "<c-cr>", "<cmd>MoltenEvaluateLine<cr>", desc = "Molten evaluate line" },
      { "<c-cr>", ":<C-u>MoltenEvaluateVisual<cr>gv", desc = "Molten evaluate visual", mode = "x" },
      { "<c-m>", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Molten enter output" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    opts = function()
      local path = require("mason-registry").get_package("debugpy"):get_install_path()

      require("dap").configurations.python = {}
      require("dap-python").setup(path .. "/venv/bin/python")
    end,
  },
  -- NOTE: disable python syntax until we can get it performing better
  -- on the large files I usually deal with, some of them not that
  -- large at all, like 500 lines. And when that highlight slowness
  -- happens, also indenting is slow, so disable that too.
  {
    "nvim-treesitter/nvim-treesitter",
    ft = "python",
    opts = function(_, opts)
      -- NOTE: re-enable highlights for now
      -- if type(opts.highlight.disable) == "table" then
      --   vim.list_extend(opts.highlight.disable, { "python" })
      -- else
      --   opts.highlight.disable = { "python" }
      -- end

      if type(opts.indent.disable) == "table" then
        vim.list_extend(opts.indent.disable, { "python" })
      else
        opts.indent.disable = { "python" }
      end
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    config = function(_, opts)
      local venv_selector = require("venv-selector")

      opts.changed_venv_hooks = {
        venv_selector.hooks.pyright,
      }

      venv_selector.setup(opts)
    end,
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Auto select virtualenv Nvim open",
        pattern = "*",
        callback = function()
          local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")

          if venv == "" then
            local names = { "venv", ".venv", "env", ".env" }
            for _, name in ipairs(names) do
              if venv ~= "" then
                break
              end

              venv = vim.fn.finddir(name, vim.fn.getcwd())
            end
          end

          if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
          end
        end,
        once = true,
      })

      return true
    end,
    opts = {
      dap_enabled = true,
    },
  },
  {
    "igorgue/vim-python-enhanced-syntax",
    -- dir = "~/Code/vim-python-enhanced-syntax",
    ft = "python",
  },
}
