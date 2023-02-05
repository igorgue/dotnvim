return {
  {
    -- navic
    "SmiteshP/nvim-navic",
    enabled = false,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    opts = function(_, opts)
      -- other ui changes
      require("lspconfig.ui.windows").default_options.border = "rounded"
      local format = require("lazyvim.plugins.lsp.format").format
      local keymaps = require("lazyvim.plugins.lsp.keymaps")
      keymaps._keys = {
        { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
        { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        { "gr", "<cmd>Lspsaga lsp_references<cr>", desc = "References" },
        { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
        { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover doc" },
        { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code action", mode = { "n", "v" } },
        { "<leader>cc", "<cmd>Lspsaga lsp_finder<cr>", desc = "Finder" },
        { "<leader>cD", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
        { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Show line diagnostics" },
        { "<leader>cf", format, desc = "Format Document", has = "documentFormatting" },
        -- stylua: ignore
        { "<leader>cf", format, desc = "Format Range", mode = "v", has = "documentRangeFormatting", },
        { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        { "<leader>co", "<cmd>Lspsaga outline<cr>", desc = "Code outline" },
        { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
        { "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Diagnostics next" },
        { "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Diagnostics prev" },
        { "[e", keymaps.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
        { "]e", keymaps.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
        { "[w", keymaps.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
        { "]w", keymaps.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      }

      return opts
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    priority = 9001,
    opts = {
      ui = {
        theme = "round",
        border = "rounded",
        code_action = " ",
        -- winblend = 20,
        colors = {
          normal_bg = "#161925",
          title_bg = "#afd7af",
          red = "#ff3525",
          magenta = "#875fff",
          orange = "#ff5f00",
          yellow = "#ffd75f",
          green = "#00af87",
          cyan = "#cbe6ff",
          blue = "#8787d7",
          purple = "#875fff",
          white = "#875fff",
          black = "#626262",
        },
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
        enable = false,
        show_file = false,
        click_support = function(node, clicks, button, modifiers)
          -- To see all avaiable details: vim.pretty_print(node)
          local st = node.range.start
          local en = node.range["end"]
          if button == "l" then
            if clicks == 2 then
              -- double left click to do nothing
            else -- jump to node's starting line+char
              vim.fn.cursor({ st.line + 1, st.character + 1 })
            end
          elseif button == "r" then
            if modifiers == "s" then
              print("lspsaga") -- shift right click to print "lspsaga"
            end -- jump to node's ending line+char
            vim.fn.cursor({ en.line + 1, en.character + 1 })
          elseif button == "m" then
            -- middle click to visual select node
            vim.fn.cursor({ st.line + 1, st.character + 1 })
            vim.cmd("normal v")
            vim.fn.cursor({ en.line + 1, en.character + 1 })
          end
        end,
      },
      outline = {
        auto_preview = false,
        auto_enter = false,
        auto_refresh = false,
      },
    },
  },
}
