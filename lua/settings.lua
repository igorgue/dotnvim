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
vim.opt.updatetime = 12 -- very low update time for fast fps

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
vim.api.nvim_set_keymap("n", "<C-p>", ":Telescope git_files<CR>", {})
vim.api.nvim_set_keymap("n", "<S-C-p>", ":Telescope live_grep<CR>", {})
vim.api.nvim_set_keymap("n", "<C-n>", ":Telescope find_files<CR>", {})

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
local cmp = require("cmp")
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

local winhighlight = "Normal:Normal,FloatBorder:VertSplit,CursorLine:CursorLine,Search:Search"
local luasnip = require("luasnip")
local mapping = {
  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  ["<C-f>"] = cmp.mapping.scroll_docs(4),
  -- ["<Tab>"] = cmp.mapping.select_next_item(),
  -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  ["<C-Space>"] = cmp.mapping.complete(),
  ["<C-e>"] = cmp.mapping.abort(),
  ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
}

-- cmp plugin
cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered({ winhighlight = winhighlight }),
      documentation = cmp.config.window.bordered({ winhighlight = winhighlight }),
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu', },
      format = require("lspkind").cmp_format({
        with_text = false,
      })
    },
    mapping = cmp.mapping.preset.insert(mapping),
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

-- mason
require("mason").setup()

-- mason extexnsions
-- "null-ls" linting
require("null-ls").setup({})

-- lsp config mason
require("mason-lspconfig").setup({
    ensure_installed = { "omnisharp", "csharp-language-server", "elixir-ls", "pyright" },
    automatic_instalation = true,
})

-- formatter mason
-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}

-- setup LSP
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- XXX since we use cmp we don't need this I think
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

-- python
require("lspconfig").pyright.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

-- semshi config
vim.cmd([[
    let g:semshi#simplify_markup=0

    exe 'hi pythonBuiltinFunc guifg=none ctermfg=none'
    exe 'hi pythonBuiltinObj guifg=none ctermfg=none'
    exe 'hi pythonBuiltinType guifg=none ctermfg=none'
]])

-- csharp
-- use vscode omnisharp install
-- local omnisharp_dll = os.getenv("HOME") .. "/.vscode/extensions/ms-dotnettools.csharp-1.25.0-linux-x64/.omnisharp/1.39.0-net6.0/OmniSharp.dll"
require'lspconfig'.omnisharp.setup {
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
    -- NOTE to use the same install as vscode
    -- cmd = { "dotnet", omnisharp_dll, "--hostPID", tostring(pid) },
    capabilities = capabilities,
    on_attach = on_attach,

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

-- omnisharp-vim config, related to ^^ (skips auto complete settings)
vim.cmd([[
augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  autocmd FileType cs nmap <silent> <buffer> \[\[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> \]\] <Plug>(omnisharp_navigate_down)

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END
]])

local omnisharp_bin = home .. "/.local/share/nvim/mason/packages/omnisharp/OmniSharp.dll"
vim.g.OmniSharp_server_path = omnisharp_bin
vim.g.OmniSharp_diagnostic_showid = 1
vim.g.OmniSharp_highlighting = 3
vim.g.OmniSharp_diagnostic_overrides = "None"
vim.g.OmniSharp_popup = 1
vim.g.OmniSharp_selector_findusages = "fzf"
vim.g.OmniSharp_selector_ui = "fzf"
vim.g.OmniSharp_timeout = 60000
vim.g.OmniSharp_server_type = "roslyn"
vim.g.OmniSharp_server_use_net6 = 1
vim.g.OmniSharp_server_stdio = 1

-- elixir
-- XXX handled by mason
-- local elixir_ls_bin = home .. "/Opt/elixir-ls/release/language_server.sh"
require("lspconfig").elixirls.setup {
    -- cmd = { elixir_ls_bin },
    capabilities = capabilities,
    on_attach = on_attach
}

-- nim
require("lspconfig").nimls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

-- ts and js
require'lspconfig'.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

-- gitsigns
require("gitsigns").setup()

-- lualine
require('lualine').setup()

-- nerdtree lua
require("nvim-tree").setup {
    filters = { custom = { "^.git$" } }
}

-- gist
vim.g.gist_clip_command = "xclip --selection clipboard"

-- rainbow treesitter
require("nvim-treesitter.configs").setup {
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        colors = { "#ff8787", "#ffd7ff", "#00af87", "#875fff", "#9e9e9e" }, -- table of hex strings
        termcolors = { "210", "225", "36", "104", "247" }, -- table of colour name strings
    }
}

-- colorizer
require("colorizer").setup({"*"}, { mode = "foreground" })
