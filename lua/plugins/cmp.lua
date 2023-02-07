return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "ray-x/cmp-treesitter",
      "saadparwaiz1/cmp_luasnip",
      "tamago324/cmp-zsh",
      "uga-rosa/cmp-dictionary",
      "amarakon/nvim-cmp-fonts",
      "onsails/lspkind.nvim",
    },
    version = false,
    event = "InsertEnter",
    lazy = false,
    opts = function(_, _)
      local cmp = require("cmp")
      local sources = {}
      if vim.fn.has("win32") == 1 then
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lua" },
        }, {
          { name = "treesitter" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
          { name = "buffer" },
          { name = "fonts", options = { space_filter = "-" } },
          { name = "crates" },
        })
      else
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lua" },
        }, {
          { name = "treesitter" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
          { name = "zsh" }, -- problems in windows
          { name = "buffer" },
          { name = "fonts", options = { space_filter = "-" } },
          { name = "crates" },
        })
      end

      if vim.fn.has("win32") == 1 then
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lua" },
        }, {
          { name = "treesitter" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
          { name = "buffer" },
          { name = "fonts", options = { space_filter = "-" } },
        })
      else
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lua" },
        }, {
          { name = "treesitter" },
          { name = "path" },
          { name = "spell" },
          { name = "dictionary" },
          { name = "zsh" }, -- problems in windows
          { name = "buffer" },
          { name = "fonts", options = { space_filter = "-" } },
        })
      end

      local winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search"

      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").load()

      -- local mapping for nvim-cmp.
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))

        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- <Tab> is used by Copilot, I found the plugin doesn't work
      -- if I use <Tab> for nvim-cmp or any other plugin
      local mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.mapping.complete({})
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-j>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm(),
      }

      -- cmp plugin
      local cmp_symbols = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "nvim_lsp_document_symbol" },
          { name = "buffer" },
          { name = "dictionary" },
          { name = "spell" },
          { name = "path" },
        }),
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_document_symbol" },
          { name = "dictionary" },
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path", options = { trailing_slash = true, label_trailing_slash = true } },
          { name = "dictionary" },
          { name = "buffer" },
        }),
      })

      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered({ winhighlight = winhighlight }),
          documentation = cmp.config.window.bordered({ winhighlight = winhighlight }),
          preview = cmp.config.window.bordered({ winhighlight = winhighlight }),
        },
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol",
            ellipsis_char = "…",
            menu = {
              nvim_lsp = "lsp",
              nvim_lua = "lua",
              luasnip = "snip",
              buffer = "buf",
              path = "path",
              calc = "calc",
              vsnip = "snip",
              nvim_lsp_signature_help = "sign",
              treesitter = "ts",
              spell = "spel",
              dictionary = "dict",
              zsh = "zsh",
              ["vim-dadbod-completion"] = "db",
            },
            symbol_map = cmp_symbols,
          }),
        },
        mapping = cmp.mapping.preset.insert(mapping),
        sources = sources,
      }
    end,
  },
}
