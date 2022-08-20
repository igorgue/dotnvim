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
vim.opt.ttyfast = true -- smoother changes
vim.opt.shortmess = "atI" -- abbreviate messages
vim.opt.backupdir = "/tmp" -- backup directory
vim.opt.showtabline = 1 -- always show the tab line
vim.opt.hidden = true -- has to do with undo in buffer I think...
vim.opt.cursorline = true -- show cursor where my cursor is...
vim.opt.lazyredraw = true -- better redrawing of text
vim.opt.termguicolors = true -- 24 bit term gui colors
vim.opt.modeline = true -- use modeline overrides
vim.opt.spell = false -- set spell
vim.opt.spelllang = { 'en_us' } -- set us spell

vim.keymap.set("n", "<leader>1", ":NerdTreeToggle<CR>")
vim.keymap.set("n", "<leader>2", ":NerdTreeToggle<CR>")

-- tabs... got lazy again
vim.cmd([[
    nnoremap <silent> <Tab>j :tabnext<CR>
    nnoremap <silent> <Tab>l :tabnext<CR>

    nnoremap <silent> <Tab>h :tabprevious<CR>
    nnoremap <silent> <Tab>k :tabprevious<CR>

    nnoremap <silent> <Tab>x :tabclose<CR>
    nnoremap <silent> <Tab>q :tabclose<CR>

    nnoremap <silent> <Tab>n :tabnew<CR>
    nnoremap <silent> tj :tabnext<CR>
    nnoremap <silent> tl :tabnext<CR>

    nnoremap <silent> th :tabprevious<CR>
    nnoremap <silent> tk :tabprevious<CR>

    nnoremap <silent> tx :tabclose<CR>
    nnoremap <silent> tq :tabclose<CR>

    nnoremap <silent> tn :tabnew<CR>
]])

-- autocomplete options
vim.opt.completeopt=menu,menuone,noselect

-- autocommands... here I got lazy
vim.cmd([[
    " Remember last location in file
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal g'\"" | endif

    au BufRead,BufNewFile {*.local} set ft=vim

    " Make Python follow PEP8 (http://www.python.org/dev/peps/pep-0008/)
    au FileType python set softtabstop=4 tabstop=4 shiftwidth=4

    au FileType less set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType slim set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType sql set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType cs set softtabstop=4 tabstop=4 shiftwidth=4

    " Code indentation and file detection
    " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
    au BufRead,BufNewFile {Procfile,Procfile.*,Gemfile,Rakefile,Capfile,Vagrantfile,Thorfile,*.ru,*.feature} set ft=ruby
    au BufNewFile,BufRead *.feature setlocal tabstop=2 shiftwidth=2 softtabstop=2

    " Code indentation
    au FileType nim setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType crystal setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType coffee setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType vuejs setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType haskell setlocal ai
    au FileType less setlocal ai
    au FileType less setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType scala setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType xhtml setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType xml setlocal tabstop=2 shiftwidth=2 softtabstop=2
    au FileType lua setlocal tabstop=4 shiftwidth=4 softtabstop=4
    au BufEnter *.tsx setlocal tabstop=2 shiftwidth=2 softtabstop=2

    " Fix issue when doing syntax highlight
    au BufEnter *.html :syntax sync fromstart
]])

-- telescope
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope git_files<CR>', {})
vim.api.nvim_set_keymap('n', '<S-C-p>', ':Telescope live_grep<CR>', {})
vim.api.nvim_set_keymap('n', '<C-n>', ':Telescope find_files<CR>', {})

-- setup nvim-cmp.
local cmp = require"cmp"

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu', },
      format = require("lspkind").cmp_format({
        with_text = false,
      })
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
      { name = "luasnip" }, -- For luasnip users.
      { name = "nvim_lua" },
      { name = "nvim_lsp_signature_help" },
      { name = "treesitter" },
      { name = "path" },
      { name = "spell" },
      { name = "dictionary" },
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

-- gitsigns
require("gitsigns").setup()

-- lualine
require('lualine').setup()
