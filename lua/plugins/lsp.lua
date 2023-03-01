return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keymaps = require("lazyvim.plugins.lsp.keymaps")
      local ui_windows = require("lspconfig.ui.windows")
      local format = require("lazyvim.plugins.lsp.format").format

      keymaps._keys = {
        { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
        { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
        { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover doc", silent = true },
        { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code action", mode = { "n", "v" } },
        { "<leader>cc", "<cmd>Lspsaga lsp_finder<cr>", desc = "Finder" },
        { "<leader>cD", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
        { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Show line diagnostics" },
        { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
        -- stylua: ignore
        { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting", },
        { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
        { "<leader>cL", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>cl", vim.lsp.codelens.run, desc = "Run codelens" },
        { "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Diagnostics next" },
        { "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Diagnostics prev" },
        { "[e", keymaps.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
        { "]e", keymaps.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
        { "[w", keymaps.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
        { "]w", keymaps.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      }

      ui_windows.default_options.border = "rounded"

      opts.servers.vimls = {}
      opts.servers.bashls = {}

      opts.setup.clangd = function(_, clangd_opts)
        clangd_opts.capabilities.offsetEncoding = { "utf-8" }
      end

      return opts
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Lspsaga",
    config = function(client, opts)
      local keymap = vim.keymap
      local default_opts = { silent = true, noremap = true }

      require("lspsaga").setup(opts)

      pcall(vim.api.nvim_del_keymap, "n", "<leader>co")

      if client.name == "dartls" then
        keymap.set("n", "<leader>co", "<cmd>FlutterOutlineToggle<cr>", default_opts)
      else
        keymap.set("n", "<leader>co", "<cmd>Lspsaga outline<cr>", default_opts)
      end

      -- HACK: for saga colors to work with colorscheme
      pcall(vim.cmd, "colorscheme " .. vim.g.colors_name)
    end,
    opts = {
      ui = {
        theme = "round",
        border = "rounded",
        code_action = " ",
      },
      lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = true,
        virtual_text = false,
      },
      rename = {
        quit = "<esc>",
        exec = "<CR>",
        in_select = false,
      },
      symbol_in_winbar = {
        enable = true,
        show_file = true,
        click_support = function(node, clicks, button, modifiers)
          -- To see all avaiable details: vim.pretty_print(node)
          local st = node.range.start
          local en = node.range["end"]
          local fn = vim.fn

          if button == "l" then
            if clicks == 2 then
              -- double left click to do nothing
            else -- jump to node's starting line+char
              fn.cursor({ st.line + 1, st.character + 1 })
            end
          elseif button == "r" then
            if modifiers == "s" then
              print("lspsaga") -- shift right click to print "lspsaga"
            end -- jump to node's ending line+char
            fn.cursor({ en.line + 1, en.character + 1 })
          elseif button == "m" then
            -- middle click to visual select node
            fn.cursor({ st.line + 1, st.character + 1 })
            vim.cmd("normal v")
            fn.cursor({ en.line + 1, en.character + 1 })
          end
        end,
        color_mode = true,
      },
      outline = {
        auto_preview = false,
        auto_enter = false,
        auto_refresh = false,
      },
      finder = {
        max_height = 0.8,
      },
    },
    keys = {
      { "<leader>co", nil, desc = "Code outline" },
      { "<leader>t", "<cmd>Lspsaga term_toggle<cr>", desc = "Terminal" },
    },
  },
}
