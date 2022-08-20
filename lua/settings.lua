require("global_settings")

-- my theme: danger
vim.opt.background = "dark"
vim.cmd("colorscheme danger")

vim.opt.encoding = "utf-8"

-- tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- completion menu
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,list:full"
vim.opt.wildignore:append("*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,*.pyc,*.dll,*.pdb,*.DS_Store,*.db,env,*/debug/*,*/Debug/*,*/publish/*")

vim.opt.undofile = true

vim.opt.tags = "tags;$HOME/.config/nvim/tags/;$HOME/tmp/tags/" -- find ctags
vim.opt.listchars = [[tab:▸\ ,eol:¬]] -- listchars for invisibles
vim.opt.mouse = "a" -- fix mouse
vim.opt.ls = 2 -- status line always show
vim.opt.scrolloff = 5 -- show 5 lines before cursor always 
vim.opt.showcmd = true -- display incomplete commands
vim.opt.showmode = true -- display current mode
vim.opt.linebreak = true -- show line breaks
vim.opt.wrap = true -- wrap lines
vim.opt.title = true -- title in the console
vim.opt.sm = true -- show matching braces
vim.opt.ttyfast = true -- smoother changes
vim.opt.shortmess = "atI" -- abbreviate messages
vim.opt.backupdir = "/tmp" -- backup directory
vim.opt.showtabline = 1 -- always show the tab line
vim.opt.hidden = true -- has to do with undo in buffer I think...
vim.opt.cursorline = true -- show cursor where my cursor is...
vim.opt.lazyredraw = true -- better redrawing of text
vim.opt.termguicolors = true -- 24 bit term gui colors

vim.keymap.set("n", "<leader>1", ":NerdTreeToggle<CR>")
vim.keymap.set("n", "<leader>2", ":NerdTreeToggle<CR>")

-- autocomplete options
vim.opt.completeopt=menu,menuone,noselect

-- setup nvim-cmp.
local cmp = require"cmp"

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        -- require("snippy").expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      -- { name = "vsnip" }, -- For vsnip users.
      { name = "luasnip" }, -- For luasnip users.
      -- { name = "ultisnips" }, -- For ultisnips users.
      -- { name = "snippy" }, -- For snippy users.
      { name = "nvim_lua" },
      { name = "nvim_lsp_signature_help" },
      { name = "treesitter" },
      { name = "path" },
    }, {
      { name = "buffer" },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = "buffer" },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "nvim_lsp_document_symbol" }
    }, {
      { name = "buffer" }
    }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
      { name = "path" }
    }, {
      { name = "cmdline" }
    })
})

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Replace <YOUR_LSP_SERVER> with each lsp server you"ve enabled.
require("lspconfig")["pyright"].setup {
    capabilities = capabilities
}
