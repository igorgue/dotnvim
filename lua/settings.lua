require("os")
require("global_settings")

local home = os.getenv("HOME") or ""
local pid = vim.fn.getpid()
local util = require("lspconfig").util

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
vim.opt.spelllang = { "en_us" } -- set us spell

vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>2", ":TagbarToggle<CR>")

-- nerd commenter stuff
vim.g.NERDCustomDelimiters = {
    nim = { left = "# ", right = "" },
    python = { left = "# ", right = "" },
    ruby = { left = "# ", right = "" },
    json = { left = "// ", right = "" },
    cs = { left = "// ", right = "" },
    lua = { left = "-- ", right = "" },
    sql = { left = "-- ", right = "" },
}

-- tabs...
vim.api.nvim_set_keymap("n", "<Tab>j", ":tabnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Tab>l", ":tabnext<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<Tab>h", ":tabprevious<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Tab>k", ":tabprevious<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<Tab>x", ":tabclose<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Tab>q", ":tabclose<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<Tab>n", ":tabnew<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "tj", ":tabnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "tl", ":tabnext<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "th", ":tabprevious<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "tk", ":tabprevious<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "tx", ":tabclose<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "tq", ":tabclose<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "tn", ":tabnew<CR>", { noremap = true, silent = true })

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

    " Jsonc (json with comments) support
    au FileType json syntax match Comment +\/\/.\+$+

    " Support for csharp script
    au BufRead,BufNewFile *.csx set filetype=cs
]])

-- telescope
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope git_files<CR>', {})
vim.api.nvim_set_keymap('n', '<S-C-p>', ':Telescope live_grep<CR>', {})
vim.api.nvim_set_keymap('n', '<C-n>', ':Telescope find_files<CR>', {})

-- windowze config
if vim.fn.has("win32") == 1 then
    vim.opt.shell = "powershell"
    vim.opt.shellcmdflag = [[-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command]]
    vim.opt.shellpipe = [[\|]]
    vim.opt.shellredir = [[\|\ Out-File\ -Encoding\ UTF8]]
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
else
    if vim.fn.executable("zsh") == 1 then
        vim.opt.shell = "zsh"
    else
        vim.opt.shell = "bash"
    end
end

-- setup nvim-cmp.
local cmp = require"cmp"
local sources = {}

if vim.fn.has("win32") == 1 then
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" }, -- For luasnip users.
      { name = "nvim_lua" },
      { name = "nvim_lsp_signature_help" },
      { name = "treesitter" },
      { name = "path" },
      { name = "spell" },
      { name = "dictionary" },
      -- { name = "zsh" }, -- problems in windows
    }, {
      { name = "buffer" },
    })
else
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" }, -- For luasnip users.
      { name = "nvim_lua" },
      { name = "nvim_lsp_signature_help" },
      { name = "treesitter" },
      { name = "path" },
      { name = "spell" },
      { name = "dictionary" },
      { name = "zsh" }, -- problems in windows
    }, {
      { name = "buffer" },
    })
end

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
    sources = sources
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

-- python
require("lspconfig").pyright.setup {
    capabilities = capabilities
}

-- csharp
-- use vscode omnisharp install
-- local omnisharp_bin = os.getenv("HOME") .. "/.vscode/extensions/ms-dotnettools.csharp-1.25.0-linux-x64/.omnisharp/1.39.0-net6.0/OmniSharp.dll"
local omnisharp_bin = home .. "/Opt/omnisharp-linux-x64-net6.0/OmniSharp.dll"
require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", omnisharp_bin, "--hostPID", tostring(pid) },
    capabilities = capabilities,

    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    -- enable_ms_build_load_projects_on_demand = true,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = true,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = true,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = true,

    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    sdk_include_prereleases = true,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    -- analyze_open_documents_only = true,

    root_dir = function(file, _)
        if file:sub(-#".csx") == ".csx" then
            return util.path.dirname(file)
        end
        return util.root_pattern("*.sln")(file) or util.root_pattern("*.csproj")(file)
    end,
}

-- elixir
local elixir_ls_bin = home .. "/.elixir-ls/release/language_server.sh"
require("lspconfig").elixirls.setup {
    cmd = { elixir_ls_bin }
}

-- nim
require("lspconfig").nimls.setup {}

-- ts and js
require'lspconfig'.tsserver.setup {}

-- gitsigns
require("gitsigns").setup()

-- lualine
require('lualine').setup()

-- nerdtree lua
require("nvim-tree").setup {
    filters = { custom = { "^.git$" } }
}

-- gist
vim.g.gist_clip_command = "xsel --clipboard --input"

-- rainbow treesitter
require("nvim-treesitter.configs").setup {
    highlight = {
    },
    -- ...
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    }
}
