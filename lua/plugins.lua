return require("packer").startup({
    function()
        -- colorschemes
        -- use "~/Code/danger" -- danger colorscheme (for development)
        use("igorgue/danger") -- danger colorscheme
        use("sainnhe/edge") -- light colorscheme

        use("wbthomason/packer.nvim") -- packer update itself

        -- telescope (picker) and plugins
        use("nvim-telescope/telescope.nvim")
        use("nvim-telescope/telescope-ui-select.nvim")
        use("ghassan0/telescope-glyph.nvim")
        use("xiyaowong/telescope-emoji.nvim")

        -- AI plugins
        use("github/copilot.vim") -- Github copilot
        use("aduros/ai.vim") -- openai plugin

        use("neovim/nvim-lspconfig") -- native LSP support

        use({ "L3MON4D3/LuaSnip", run = "make install_jsregexp" }) -- Lua based snippets
        use("rafamadriz/friendly-snippets") -- snippets for LuaSnip

        use("onsails/lspkind.nvim") -- Nice kinds icons on lsp menus

        -- oldest trick to select blocks with vii
        use("michaeljsmith/vim-indent-object") -- selection of indentation blocks

        -- show indentation lines
        use("lukas-reineke/indent-blankline.nvim")

        -- start page
        use("goolord/alpha-nvim")

        -- sessions manager
        use("rmagatti/auto-session")

        -- Comment.nvim
        use("numToStr/Comment.nvim") -- comment plugin

        -- tpope
        use("tpope/vim-surround") -- wrap objects with text
        use("tpope/vim-git") -- git stuff from tpope
        use("tpope/vim-fugitive") -- more git stuff
        use("tpope/vim-dadbod") -- dadbod

        -- dadbod plugins
        use("kristijanhusak/vim-dadbod-ui")
        use("kristijanhusak/vim-dadbod-completion")

        -- kyazdani42's plugins
        -- a file manager
        use({ "kyazdani42/nvim-tree.lua", tag = "nightly" })

        use("kyazdani42/nvim-web-devicons") -- file icons

        use("norcalli/nvim-colorizer.lua") -- colors
        use("nvim-lua/plenary.nvim") -- utils for nvim

        -- framework for cool syntax plugins
        use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

        use("nvim-treesitter/playground") -- playground for treesitter
        use("David-Kunz/markid") -- markid, variables colors for treesitter
        use("p00f/nvim-ts-rainbow") -- shows rainbow matching braces for treesitter
        use("nvim-treesitter/nvim-treesitter-refactor") -- refactor plugin
        use("nvim-treesitter/nvim-treesitter-context") -- sticky context for treesitter
        use("theHamsta/nvim-treesitter-pairs") -- pairs
        use("theHamsta/nvim-dap-virtual-text") -- virtual text for dap
        use("windwp/nvim-ts-autotag") -- auto close tags
        use("andymass/vim-matchup") -- show matching pairs

        use("lewis6991/gitsigns.nvim") -- changes on git
        -- lualine
        use("nvim-lualine/lualine.nvim") -- status line

        -- mason package manager for lsp and other services
        use({ "williamboman/mason.nvim" })

        -- mason extensions
        use("williamboman/mason-lspconfig.nvim")

        -- folke plugins
        use("folke/trouble.nvim") -- nice diagnistics menu for lsp
        use("folke/todo-comments.nvim") -- tasks comments, "todo" comments
        use("folke/noice.nvim") -- noice for neovim
        use("folke/twilight.nvim")
        use("folke/zen-mode.nvim")
        use("folke/neodev.nvim")

        -- nui needed for noice
        use("MunifTanjim/nui.nvim")

        -- saga
        use({ "glepnir/lspsaga.nvim", branch = "main" })
        use("glepnir/hlsearch.nvim")

        -- formatter
        use("mhartington/formatter.nvim")

        -- mfussenegger's plugins
        use("mfussenegger/nvim-dap") -- debug adapter protocol
        use("mfussenegger/nvim-dap-python") -- dap for python
        use("mfussenegger/nvim-lint") -- linter plugin

        -- rcarriga plugins
        use("rcarriga/nvim-dap-ui") -- dap ui
        use("rcarriga/nvim-notify") -- general notifications

        -- csharp
        use("OmniSharp/omnisharp-vim")
        use("Hoffs/omnisharp-extended-lsp.nvim")

        -- elixir
        use("elixir-editors/vim-elixir")
        use("mhanberg/elixir.nvim")

        -- dart
        use("dart-lang/dart-vim-plugin")

        -- flutter
        use("akinsho/flutter-tools.nvim")
        use("Nash0x7E2/awesome-flutter-snippets") -- for LuaSnip

        -- js and ts
        use("pangloss/vim-javascript")
        use("peitalin/vim-jsx-typescript")
        use("leafgarland/typescript-vim")

        -- hrsh7th's nvim lsp plugins
        use("hrsh7th/nvim-cmp")
        use("hrsh7th/cmp-nvim-lua")
        use("hrsh7th/cmp-buffer")
        use("hrsh7th/cmp-cmdline")
        use("hrsh7th/cmp-nvim-lsp")
        use("hrsh7th/cmp-nvim-lsp-document-symbol")
        use("hrsh7th/cmp-path")

        -- nvim-cmp's plugins
        use("f3fora/cmp-spell")
        use("ray-x/cmp-treesitter")
        use("saadparwaiz1/cmp_luasnip") -- snippets required for hrsh7th's plugins
        use("tamago324/cmp-zsh")
        use("uga-rosa/cmp-dictionary")
        use("amarakon/nvim-cmp-fonts")

        -- redis
        use("junegunn/vim-redis")

        -- ziontee113 plugins
        use("ziontee113/color-picker.nvim")
        use("ziontee113/query-secretary")

        -- schemastore
        use("b0o/schemastore.nvim")

        -- gist
        use({"rudylee/nvim-gist", run = ":UpdateRemotePlugins" })
    end,
    config = {
        display = {
            prompt_border = "rounded",
        },
    },
})
