require("global_settings")

local ui_utils = require("ui_utils")
local file_utils = require("file_utils")
local text_utils = require("text_utils")
local lsp_utils = require("lsp_utils")

local opts = { noremap = true, silent = true }

local dbs = {}
if vim.api.nvim_get_runtime_file("lua/dbs_local.lua", false)[1] then
    dbs = require("dbs_local")
end

local home = os.getenv("HOME") or ""

-- tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- completion menu
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,list:full"
vim.opt.wildignore:append(
    "*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,*.pyc,*.dll,*.pdb,*.DS_Store,*.db,env,*/debug/*,*/Debug/*,*/publish/*"
)

vim.opt.undofile = true

vim.opt.tags = "tags;" .. home .. "/.config/nvim/tags/;" .. home .. "/tmp/tags/" -- find ctags
vim.opt.listchars = [[tab:▸\ ,eol:↴]] -- listchars for invisibles
vim.opt.mouse:append({ a = true }) -- mouse all
vim.opt.scrolloff = 5 -- show 5 lines before cursor always
vim.opt.linebreak = true -- show line breaks
vim.opt.wrap = true -- wrap lines
vim.opt.title = true -- title in the console
vim.opt.ttyfast = true -- smoother changes
vim.opt.shortmess = "atSTIF" -- abbreviate messages
vim.opt.backupdir = "/tmp" -- backup directory
vim.opt.hidden = true -- has to do with undo in buffer I think...
vim.opt.cursorline = false -- show cursor where my cursor is...
vim.opt.lazyredraw = false -- better redrawing of text
vim.opt.termguicolors = true -- 24 bit term gui colors
vim.opt.modeline = true -- use modeline overrides
vim.opt.spell = false -- set spell
vim.opt.spelllang = { "en_us" } -- set us spell
vim.opt.updatetime = 12 -- very low update time for fast fps
vim.opt.showcmd = true -- display incomplete commands
vim.opt.showmode = false -- disable mode since we use lualine
vim.opt.showbreak = "﬌" -- show line breaks
vim.opt.showtabline = 1 -- only show tabs if there's at least 2
vim.opt.laststatus = 3 -- show only 1 status line

if vim.version().minor == 9 then
    -- merges number with sign column
    vim.opt.statuscolumn = "%=%l%s%C"
    -- vim.opt.number = true
end

-- tabs...
vim.keymap.set("n", "<leader>tj", "<cmd>tabnext<CR>", opts)
vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<CR>", opts)
vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<CR>", opts)
vim.keymap.set("n", "<leader>tk", "<cmd>tabprevious<CR>", opts)
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", opts)
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", opts)
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", opts)

-- autocomplete options
vim.opt.completeopt = "menu,menuone,noselect"

-- diff settings
vim.opt.diffopt:append({ linematch = 60 })

vim.cmd([[
    if &diff
        augroup diff
            autocmd!
            " autocmd BufEnter * if &diff | set laststatus=2 | else | set laststatus=3 | endif
            autocmd BufEnter * if &diff | map <leader>1 :diffget LOCAL<CR> | endif
            autocmd BufEnter * if &diff | map <leader>2 :diffget BASE<CR> | endif
            autocmd BufEnter * if &diff | map <leader>3 :diffget REMOTE<CR> | endif
        augroup END
    endif

    " Remember last location in file
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

    " Make Python follow PEP8 (http://www.python.org/dev/peps/pep-0008/)
    au FileType python set softtabstop=4 tabstop=4 shiftwidth=4

    au FileType less set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType css set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType slim set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType sql set softtabstop=2 tabstop=2 shiftwidth=2
    au FileType cs set softtabstop=4 tabstop=4 shiftwidth=4

    " Code indentation and file detection
    " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
    au BufRead,BufNewFile {Procfile,Procfile.*,Gemfile,Rakefile,Capfile,Vagrantfile,Thorfile,*.ru,*.feature} set ft=ruby
    au BufRead,BufNewFile {*.crontab} set ft=crontab
    au BufRead,BufNewFile {*.redis} set ft=redis
    au BufNewFile,BufRead *.feature set tabstop=2 shiftwidth=2 softtabstop=2

    " Code indentation
    au FileType nim set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType dart set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType yaml set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType crystal set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType coffee set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType json set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType javascript set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType vuejs set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType haskell set ai
    au FileType less set ai
    au FileType less set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType scala set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType html set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType xhtml set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType xml set tabstop=2 shiftwidth=2 softtabstop=2
    au FileType lua set tabstop=4 shiftwidth=4 softtabstop=4
    au BufEnter *.tsx set tabstop=2 shiftwidth=2 softtabstop=2

    " Fix issue when doing syntax highlight
    au BufEnter *.html :syntax sync fromstart
    au BufEnter *.dart :syntax sync fromstart
    au BufEnter *.py :syntax sync fromstart
    au BufEnter *.lua :syntax sync fromstart
    au BufEnter *.ex :syntax sync fromstart
    au BufEnter *.nim :syntax sync fromstart

    " Jsonc (json with comments) support
    au FileType json syntax match Comment +\/\/.\+$+

    " Support for csharp script
    au BufRead,BufNewFile *.csx set filetype=cs
]])

-- go to config
vim.api.nvim_create_user_command("Conf", file_utils.cd_conf, {})
vim.api.nvim_create_user_command("ConfInit", file_utils.edit_init, {})
vim.api.nvim_create_user_command("ConfSettings", file_utils.edit_settings, {})
vim.api.nvim_create_user_command("ConfPlugins", file_utils.edit_plugins, {})
vim.api.nvim_create_user_command("CdPwd", file_utils.refresh_dir, {})

-- and a simple keybind
vim.keymap.set("n", "<leader>4", "<cmd>CdPwd<cr>", opts)

-- theme helpers
vim.keymap.set("n", "<leader>x", "<Cmd>TSHighlightCapturesUnderCursor<CR>", opts)
vim.keymap.set("n", "<leader>X", ui_utils.syn_stack, opts)

vim.notify = require("notify")
vim.notify.setup({
    render = "minimal",
    timeout = 2500,
    stages = "static",
    background_colour = "#000000",
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.notify.setup({
            background_colour = ui_utils.hi_co("Normal", "bg"),
        })
    end,
})

ui_utils.setup_tabline()

-- telescope
local telescope = require("telescope")
local actions = require("telescope.actions")

local function telescope_paste_char(char)
    vim.api.nvim_put({ char.value }, "c", false, true)
end

telescope.setup({
    defaults = {
        prompt_prefix = "   ",
        selection_caret = "   ",
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
    extensions = {
        emoji = {
            action = telescope_paste_char,
        },
        glyph = {
            action = telescope_paste_char,
        },
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
    },
})

telescope.load_extension("notify")
telescope.load_extension("ui-select")
telescope.load_extension("noice")
telescope.load_extension("glyph")
telescope.load_extension("emoji")

vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>Telescope git_files<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>P", "<cmd>Telescope live_grep<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>Telescope find_files<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>m", "<cmd>Telescope marks<cr>", opts)

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

assert(cmp, not nil)

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
-- <Tab> is used by Copilot, I found the pluggin doesn't work
-- if I use <Tab> for nvim-cmp or any other plugin
local mapping = {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-n>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif text_utils.has_words_before() then
            cmp.complete()
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
    ["<C-Space>"] = cmp.mapping.complete(),
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

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
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
})

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

-- mason
require("mason").setup({
    ui = {
        border = "rounded",
        winhighlight = winhighlight,
    },
})

-- lsp config mason
require("mason-lspconfig").setup({
    ensure_installed = {},
    automatic_instalation = true,
})

-- diagnostics signs
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticWarning" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticInformation" })
vim.fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticHint" })

-- diagnostics config
vim.diagnostic.config(lsp_utils.diagnostic_config)

-- trouble
require("trouble").setup({
    auto_open = false,
    auto_close = true,
    auto_preview = true,
    auto_fold = true,
    use_diagnostic_signs = true,
})

-- toggle trouble with t (for local file) or T (for all files)
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
local formatter_util = require("formatter.util")
require("formatter").setup({
    -- Enable or disable logging
    logging = true,

    -- All formatter configurations are opt-in
    filetype = {
        lua = {
            function()
                return {
                    exe = "stylua",
                    args = {
                        "--search-parent-directories",
                        "--stdin-filepath",
                        formatter_util.escape_path(formatter_util.get_current_buffer_file_path()),
                        "--indent-type",
                        "Spaces",
                        "--",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },

        dart = {
            function(t)
                t = t or {}

                local args = { "--output show", "--fix" }
                if t.line_length ~= nil then
                    table.insert(args, "--line-length " .. t.line_length)
                end

                return {
                    exe = "dart format",
                    args = args,
                    stdin = true,
                }
            end,
        },

        java = {
            function()
                local buffn = formatter_util.escape_path(formatter_util.get_current_buffer_file_path())
                local indent_size = vim.api.nvim_buf_get_option(0, "tabstop")

                return {
                    exe = "clang-format",
                    args = {
                        '-style="{IndentWidth: ' .. indent_size .. '}"',
                        "-assume-filename=java",
                        buffn,
                    },
                    stdin = true,
                }
            end,
        },

        javascript = {
            require("formatter.filetypes.javascript").prettier,
        },

        c = {
            require("formatter.filetypes.c").clangformat,
        },

        typescript = {
            require("formatter.filetypes.javascript").prettier,
        },

        json = {
            require("formatter.filetypes.json").prettier,
        },

        python = {
            require("formatter.filetypes.python").isort,
            require("formatter.filetypes.python").black,
        },

        htmldjango = {
            function()
                local buffn = formatter_util.escape_path(formatter_util.get_current_buffer_file_path())

                return {
                    exe = "djlint",
                    args = { "--reformat", buffn },
                    stdin = false,
                    transform = function(text)
                        vim.cmd("e!")

                        return text
                    end,
                }
            end,
        },

        sql = {
            require("formatter.filetypes.sql").sqlformat,
        },

        rust = {
            require("formatter.filetypes.rust").rustfmt,
        },

        elixir = {
            function()
                local buffn = formatter_util.escape_path(formatter_util.get_current_buffer_file_path())

                return {
                    exe = "mix",
                    args = {
                        "format",
                        buffn,
                    },
                    stdin = false,
                    transform = function(text)
                        vim.cmd("e!")

                        return text
                    end,
                }
            end,
        },

        markdown = {
            require("formatter.filetypes.markdown").prettier,
        },

        nim = {
            function()
                local buffn = formatter_util.escape_path(formatter_util.get_current_buffer_file_path())

                return {
                    exe = "nimpretty",
                    args = {
                        "--out:" .. buffn,
                        buffn,
                    },
                    stdin = false,
                }
            end,
        },

        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

vim.keymap.set("n", "<leader>f", ":Format<CR>", opts)
vim.keymap.set("n", "<leader>F", ":FormatWrite<CR>", opts)

-- setup LSP
local lspconfig_util = require("lspconfig").util

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.cmd([[
    autocmd BufEnter,CursorHold,InsertLeave <buffer> lua if next(vim.lsp.codelens.get()) ~= nil then vim.lsp.codelens.refresh() end
]])

-- lspsaga
require("lspsaga").setup({
    ui = {
        theme = "round",
        border = "rounded",
        code_action = " ",
        -- winblend = 20,
        colors = {
            normal_bg = "#161925",
            title_bg = '#afd7af',
            red = '#ff3525',
            magenta = '#875fff',
            orange = '#ff5f00',
            yellow = '#ffd75f',
            green = '#00af87',
            cyan = '#cbe6ff',
            blue = '#8787d7',
            purple = '#875fff',
            white = '#875fff',
            black = '#626262',
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
                    vim.fn.cursor(st.line + 1, st.character + 1)
                end
            elseif button == "r" then
                if modifiers == "s" then
                    print("lspsaga") -- shift right click to print "lspsaga"
                end -- jump to node's ending line+char
                vim.fn.cursor(en.line + 1, en.character + 1)
            elseif button == "m" then
                -- middle click to visual select node
                vim.fn.cursor(st.line + 1, st.character + 1)
                vim.cmd("normal v")
                vim.fn.cursor(en.line + 1, en.character + 1)
            end
        end,
    },
    outline = {
        auto_preview = false,
        auto_enter = false,
        auto_refresh = false,
    },
})

-- lsp handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, lsp_utils.diagnostic_config)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- viml
require("lspconfig").vimls.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- python
require("lspconfig").pyright.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
            },
        },
    },
})

-- c
require("lspconfig").clangd.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
})

-- json
require("lspconfig").jsonls.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
        },
    },
})

-- vala
require("lspconfig").vala_ls.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
})

-- rust
require("lspconfig").rust_analyzer.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
})

-- dart
vim.g.dart_style_guide = 2
vim.g.dart_html_in_string = true
vim.g.dart_trailing_comma_indent = true
vim.g.dartfmt_options = { "--fix" }

-- flutter
if vim.fn.executable("flutter") == 1 then
    require("flutter-tools").setup({
        ui = {
            border = "rounded",
            notification_style = "native",
        },
        widget_guides = {
            enabled = true,
        },
        closing_tags = {
            enabled = true,
            prefix = "  ",
        },
        outline = {
            open_cmd = "botright 40vnew",
            auto_open = false,
        },
        dev_log = {
            enabled = true,
            open_cmd = "botright 5sp",
        },
        lsp = {
            on_attach = function(client, bufnr)
                lsp_utils.on_attach(client, bufnr)

                vim.keymap.set(
                    "n",
                    "<leader>2",
                    ":FlutterOutlineToggle<CR>",
                    { buffer = true, noremap = true, silent = true }
                )

                vim.cmd([[
                    augroup FlutterTools
                        autocmd!
                        autocmd FileType flutterToolsOutline noremap <buffer> <leader>2 :FlutterOutlineToggle<CR>
                    augroup END
                ]])

                require("flutter-tools").lsp_on_attach(client, bufnr)
            end,
            capabilities = lsp_utils.capabilities,
            color = {
                enabled = true,
                background = true,
            },
            settings = {
                showTodos = false,
                completeFunctionCalls = true,
                updateImportsOnRename = true,
                enableSnippets = false,
                renameFilesWithClasses = true,
            },
        },
        debugger = {
            enabled = true,
            run_via_dap = true,
            exception_breakpoints = {},
            register_configurations = function(_)
                require("dap").configurations.dart = {}
                require("dap.ext.vscode").load_launchjs()
            end,
        },
    })

    telescope.load_extension("flutter")
else
    require("lspconfig").dartls.setup({
        capabilities = lsp_utils.capabilities,
        on_attach = lsp_utils.on_attach,
    })
end

-- csharp
-- use vscode omnisharp install
-- local omnisharp_dll = home .. "/.vscode/extensions/ms-dotnettools.csharp-1.25.0-linux-x64/.omnisharp/1.39.0-net6.0/OmniSharp.dll"
require("lspconfig").omnisharp.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,

    handlers = {
        ["textDocument/definition"] = require("omnisharp_extended").handler,
    },
    -- NOTE to use the same install as vscode
    -- cmd = { "dotnet", omnisharp_dll, "--hostPID", tostring(pid) },

    enable_editorconfig_support = true,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    sdk_include_prereleases = true,

    root_dir = function(file, _)
        if file:sub(-#".csx") == ".csx" then
            return lspconfig_util.path.dirname(file)
        end
        return lspconfig_util.root_pattern("*.sln")(file) or lspconfig_util.root_pattern("*.csproj")(file)
    end,
})

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
  autocmd FileType cs nmap <silent> <buffer> <leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field

  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <leader>osgcc <Plug>(omnisharp_global_code_check)
  autocmd FileType cs nmap <silent> <buffer> <leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <leader>ossp <Plug>(omnisharp_stop_server)
augroup END
]])

local omnisharp_bin = home .. "/.local/share/nvim/mason/packages/omnisharp/omnisharp"
vim.g.OmniSharp_server_path = omnisharp_bin
vim.g.OmniSharp_diagnostic_showid = 1
vim.g.OmniSharp_highlighting = 3
vim.g.OmniSharp_diagnostic_overrides = "None"
vim.g.OmniSharp_popup = 1
vim.g.OmniSharp_timeout = 60000
vim.g.OmniSharp_server_type = "roslyn"
vim.g.OmniSharp_server_use_net6 = 1
vim.g.OmniSharp_server_stdio = 1

-- elixir
local elixir = require("elixir")
elixir.setup({
    -- specify a repository and branch
    repo = "elixir-lsp/elixir-ls",
    branch = "master",
    -- repo = "mhanberg/elixir-ls", -- defaults to elixir-lsp/elixir-ls
    -- branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option

    -- cmd = { home .. "/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },

    -- default settings, use the `settings` function to override settings
    settings = elixir.settings({
        dialyzerEnabled = true,
        dialyzerFormat = "dialyxir_long",
        -- dialyzerWarnOpts = []
        enableTestLenses = true,
        -- envVariables =
        fetchDeps = true,
        -- languageServerOverridePath =
        mixEnv = "dev",
        -- mixTarget = "host",
        -- projectDir = "",
        signatureAfterComplete = true,
        suggestSpecs = true,
        trace = {
            server = "on",
        },
    }),

    capabilities = lsp_utils.capabilities,
    on_attach = function(client, bufnr)
        local elixir_opts = { noremap = true, silent = true, buffer = bufnr }

        -- remove the pipe operator
        vim.keymap.set("n", "<leader>fp", ":ElixirFromPipe<cr>", elixir_opts)

        -- add the pipe operator
        vim.keymap.set("n", "<leader>tp", ":ElixirToPipe<cr>", elixir_opts)
        vim.keymap.set("v", "<leader>em", ":ElixirExpandMacro<cr>", elixir_opts)

        lsp_utils.on_attach(client, bufnr)
    end,
})

-- require("lspconfig").elixirls.setup({
--     on_attach = lsp_utils.on_attach,
--     capabilities = lsp_utils.capabilities,
--     cmd = { home .. "/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
--     settings = {
--         elixirLS = {
--             dialyzerEnabled = false,
--             -- dialyzerFormat = dialyxir_long"
--             -- dialyzerWarnOpts = []
--             enableTestLenses = false,
--             -- envVariables =
--             fetchDeps = false,
--             -- languageServerOverridePath =
--             -- mixEnv = "dev",
--             -- mixTarget = "debug",
--             -- projectDir = "",
--             signatureAfterComplete = false,
--             suggestSpecs = false,
--             trace = {
--                 server = "off",
--             },
--         },
--     },
-- })

-- nim
require("lspconfig").nimls.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- ts and js
require("lspconfig").tsserver.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- java
require("lspconfig").jdtls.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- c
require("lspconfig").clangd.setup({
    on_attach = lsp_utils.on_attach,
    capabilities = lsp_utils.capabilities,
})

-- lua
-- vim.lsp.set_log_level("debug")

-- FIXME: stackoverflow error...
require("lspconfig").sumneko_lua.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "use" },
            },
            completion = {
                callSnippets = "Replace",
            },
        },
    },
})

-- html
require("lspconfig").html.setup({
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
})

-- dap
local dap, dapui = require("dap"), require("dapui")

-- dap.set_log_level("TRACE")

vim.fn.sign_define(
    "DapBreakpoint",
    { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = " ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapLogPoint",
    { text = " ", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

-- dap ui
dapui.setup({
    floating = {
        border = "rounded",
    },
})

-- events for dap to automatically open the dap ui
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
end

-- dap bindings
vim.cmd([[
    nnoremap <silent> <F5> <Cmd>lua require('dap').continue()<CR>
    nnoremap <silent> <F6> <Cmd>lua require('dap').step_over()<CR>
    nnoremap <silent> <F7> <Cmd>lua require('dap').step_into()<CR>
    nnoremap <silent> <F8> <Cmd>lua require('dap').step_out()<CR>
    nnoremap <silent> <leader>b <Cmd>lua require('dap').toggle_breakpoint()<CR>
    nnoremap <silent> <leader>B <Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    nnoremap <silent> <leader>L <Cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    nnoremap <silent> <m-r> <Cmd>lua require('dap').repl.open()<CR>
    nnoremap <silent> <m-l> <Cmd>lua require('dap').run_last()<CR>
]])

-- python dap
require("dap-python").setup(home .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python")

-- elixir
dap.adapters.elixir = {
    type = "executable",
    command = home .. "/.local/share/nvim/mason/packages/elixir-ls/debugger.sh",
}

dap.configurations.elixir = {
    {
        type = "elixir",
        name = "Run Elixir Program",
        task = "phx.server",
        taskArgs = { "--trace" },
        request = "launch",
        startApps = true, -- for Phoenix projects
        projectDir = "${workspaceFolder}",
        requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs",
        },
    },
}

dap.adapters.dart = {
    type = "executable",
    command = "flutter",
    args = { "debug-adapter" },
}

dap.configurations.dart = {}
require("dap.ext.vscode").load_launchjs()

-- gitsigns
require("gitsigns").setup()

-- lualine
require("lualine").setup(ui_utils.lualine_setup_options())

-- overwrite with colorscheme specific, my own defaults
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        require("lualine").setup(ui_utils.lualine_setup_options())
    end,
})

-- nvim tree lua
require("nvim-tree").setup({
    filters = { dotfiles = true },
    renderer = {
        icons = {
            show = {
                folder_arrow = false,
            },
        },
    },
})

vim.keymap.set("n", "<leader>1", ":NvimTreeToggle<CR>", opts)

-- rainbow treesitter
require("nvim-treesitter.configs").setup({
    auto_install = true,
    highlight = {
        enable = true,
        -- disable = { "elixir" },
        -- additional_vim_regex_highlighting = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = {
        enable = true,
    },
    markid = {
        enable = true,
        -- queries = {
        --     default = [[
        --         (
        --          (identifier) @markid
        --          (#not-has-parent? @markid function_definition class_definition dotted_name)
        --         )
        --     ]],
        -- },
    },
    rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
    },
    refactor = {
        enable = true,
        clear_on_cursor_move = false,
        highlight_definitions = { enable = true },
    },
    pairs = {
        enable = true,
    },
    autotag = {
        enable = true,
    },
    matchup = {
        enable = true,
    },
})

-- some other treesitter plugins
require("treesitter-context").setup()
require("nvim-dap-virtual-text").setup({})

-- enable html parser in htmldjango file
local import_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
if import_parsers then
    local parsername = parsers.filetype_to_parsername
    parsername.htmldjango = "html"
end

local import_tag, autotag = pcall(require, "nvim-ts-autotag")
if not import_tag then
    return
end
autotag.setup({
    autotag = {
        enable = true,
    },
    filetypes = {
        "html",
        "htmldjango",
    },
})

-- colorizer
require("colorizer").setup({ "*" }, {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = true, -- "Name" codes like Blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn

    -- Available modes: foreground, background
    mode = "foreground", -- Set the display mode.
})

-- neovim dev plugin
require("neodev").setup({})

-- LspInfo rounded borders
require("lspconfig.ui.windows").default_options.border = "rounded"

-- Comment.nvim
require("Comment").setup()

-- indent.blankline
vim.g.indent_blankline_char = "▏"
vim.g.indent_blankline_enabled = false

require("indent_blankline").setup({
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = true,
})

vim.keymap.set("n", "<leader>l", function()
    if vim.g.indent_blankline_enabled then
        vim.cmd("IndentBlanklineDisable")
        vim.cmd.set("nolist")

        vim.g.indent_blankline_enabled = false
    else
        vim.cmd("IndentBlanklineEnable")
        vim.cmd.set("list")

        vim.g.indent_blankline_enabled = true
    end
end, opts)

-- dadbod ui
vim.g.dbs = dbs
vim.g.db_ui_use_nerd_fonts = true
vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql" },
    callback = function()
        cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
    end,
})

-- set the connections, maps and config edit command
vim.api.nvim_create_user_command("DBConfig", file_utils.edit_dbs_config, {})

-- todo comments
require("todo-comments").setup()

-- noice
require("noice").setup({
    cmdline = {
        enabled = true,
    },
    presets = {
        command_palette = true,
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,
    },
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
})

vim.api.nvim_set_keymap("n", "<leader>N", "<cmd>Noice history<cr>", opts)

-- session manager
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require("auto-session").setup({
    log_level = "error",
    auto_save_enabled = true,
    auto_restore_enabled = false,
    auto_session_suppress_dirs = { "~/", "~/Documents", "~/Downloads", "/" },
})

-- <leader>+s to save session
vim.keymap.set("n", "<leader>s", "<cmd>SaveSession<cr>", opts)
vim.keymap.set("n", "<leader>S", "<cmd>Autosession search<cr>", opts)

-- alpha
require("alpha").setup(ui_utils.alpha_theme().config)

vim.cmd([[
    augroup DisableIndentBlankline
        autocmd!
        autocmd FileType alpha IndentBlanklineDisable
    augroup END

    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=1
    autocmd User AlphaReady set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
]])

-- color picker
require("color-picker").setup()

vim.keymap.set("n", "<M-c>", "<cmd>PickColor<cr>", opts)
vim.keymap.set("i", "<M-c>", "<cmd>PickColorInsert<cr>", opts)

-- treesitter secretary
require("query-secretary").setup({})
vim.api.nvim_create_user_command("TsQuerySecretary", function()
    require("query-secretary").query_window_initiate()
end, {})

-- linters
local lint = require("lint")

lint.linters.djlint = {
    cmd = "djlint",
    stdin = true,
    args = { "--lint", "-" },
    ignore_exitcode = true,
    parser = require("lint.parser").from_errorformat("%t%n\\ %l:%c\\ %m"),
}

lint.linters.clippy = {
    cmd = "cargo",
    stdin = true,
    args = { "clippy" },
    ignore_exitcode = true,
    parser = require("lint.parser").from_errorformat("%t%n\\ %l:%c\\ %m"),
}

lint.linters.cpplint = {
    cmd = "cpplint",
    stdin = true,
    args = {},
    ignore_exitcode = true,
    parser = require("lint.parser").from_errorformat("%t%n\\ %l:%c\\ %m"),
}

lint.linters_by_ft = {
    python = { "pylint" },
    htmldjango = { "djlint" },
    rust = { "clippy" },
    c = { "cpplint" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave", "TextChanged" }, {
    callback = function()
        lint.try_lint()
    end,
})

vim.api.nvim_create_user_command("Lint", function()
    lint.try_lint()
end, {})

require("twilight").setup({})

local zen_mode = require("zen-mode")
local zen_mode_view = require("zen-mode.view")
zen_mode.setup({
    window = {
        backdrop = 1,
        width = 0.50,
        height = 0.90,
        options = {
            signcolumn = "no",
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = "0",
        },
    },
    plugins = {
        options = {
            enabled = true,
            ruler = false,
            showcmd = false,
            laststatus = 0,
        },
        gitsigns = { enabled = true },
        tmux = { enabled = true },
        kitty = { enabled = true, font = "+2" },
        twilight = { enabled = false },
        diagnostics = { enabled = true },
    },
})

-- FIXME: this is done like this because of a bug in zen-mode
-- shows the last line because I don't use status lines
vim.keymap.set("n", "<leader>z", function()
    if zen_mode_view.is_open() then
        vim.cmd("set wrap")
        zen_mode.close()

        return
    end

    local current_line = vim.fn.line(".")
    vim.cmd("normal! Gzt")

    -- for all filetypes use 0.45
    local zen_mode_width = 0.45

    -- how to specific width per file type
    -- if vim.bo.filetype == "java" then
    --     zen_mode_width = 0.45
    -- end

    zen_mode.toggle({
        window = {
            width = zen_mode_width,
        },
    })
    vim.cmd("set nowrap")

    -- go to current_line
    vim.cmd("normal! " .. current_line .. "G")
end, opts)
vim.keymap.set("n", "<leader>Z", "<cmd>Twilight<cr>", opts) -- twilight

-- autocommand for hlsearch.nvim for event BufRead
vim.api.nvim_create_autocmd("BufRead", {
    callback = function()
        require("hlsearch").setup()
    end,
})

-- ai.vim
vim.g.ai_no_mappings = 1

local ai_opts = { noremap = true }
vim.keymap.set("i", "<M-a>", "<esc>:AI<cr>a", ai_opts)

-- cmd mappings
vim.api.nvim_create_user_command("Nap", function()
    vim.cmd([[
        terminal ]] .. home .. [[/go/bin/nap
        normal! a
    ]])
end, {})

vim.api.nvim_create_user_command("Ranger", function()
    vim.cmd([[
        terminal ranger
        normal! a
    ]])
end, {})

-- move line up and down
vim.keymap.set("n", "<C-Up>", "ddkP", opts)
vim.keymap.set("n", "<C-Down>", "ddp", opts)
