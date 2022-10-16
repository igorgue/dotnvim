return require("packer").startup(function()
    use "igorgue/danger" -- danger colorscheme
    -- use "~/Code/danger" -- danger colorscheme (for development)

    use "wbthomason/packer.nvim" -- packer update itself
    use "nvim-telescope/telescope.nvim" -- nice interface for LSP functions (among other things)

    use "github/copilot.vim" -- Github copilot

    use "neovim/nvim-lspconfig" -- native LSP support

    use "L3MON4D3/LuaSnip" -- Lua based snippets
    use "rafamadriz/friendly-snippets" -- snippets for LuaSnip

    use "onsails/lspkind.nvim" -- Nice kinds icons on lsp menus

    -- oldest trick to select blocks with vii
	use "michaeljsmith/vim-indent-object" -- selection of indentation blocks

    use "stevearc/aerial.nvim" -- outline plugin

    -- mattn's pluggins
    use "mhinz/vim-startify" -- shows a nice startup page

    -- oldies
    use "preservim/nerdcommenter" -- comment and uncomment

    -- tpope
    use "tpope/vim-sensible" -- sensible default vim settings by tpope
    use "tpope/vim-surround" -- wrap objects with text
    use "tpope/vim-git" -- git stuff from tpope
    use "tpope/vim-fugitive" -- more git stuff

    use "sainnhe/edge" -- light theme

    use "sheerun/vim-polyglot" -- syntax hi collection

    -- kyazdani42's plugins
    use {
        "kyazdani42/nvim-tree.lua", -- a file manager
        tag = "nightly" -- optional, updated every week. (see issue #1193)
    }

    use "kyazdani42/nvim-web-devicons" -- file icons

    use "norcalli/nvim-colorizer.lua" -- colors
    use {
        "numirias/semshi", {run = ":UpdateRemotePlugins"} -- colors for Python
    }
    use "nvim-lua/plenary.nvim" -- utils for nvim
    use "gbrlsnchs/telescope-lsp-handlers.nvim"
    use {
        "nvim-treesitter/nvim-treesitter",
        {run = ":TSUpdate"}
    }
    use "nvim-treesitter/playground"
    use "David-Kunz/markid" -- markid, variables colors
    use "p00f/nvim-ts-rainbow" -- shows rainbow matching braces
    use "lewis6991/gitsigns.nvim" -- changes on git

    -- lualine
    use "nvim-lualine/lualine.nvim"

    -- mason package manager for lsp and other services
    use { "williamboman/mason.nvim" }

    -- nice diagnistics menu
    use "folke/trouble.nvim"

    -- mason extensions
    use "williamboman/mason-lspconfig.nvim"
    use "mfussenegger/nvim-dap"
    use "mhartington/formatter.nvim"

    -- notify
    use "rcarriga/nvim-notify"

    -- csharp
    use "OmniSharp/omnisharp-vim"
    use "Hoffs/omnisharp-extended-lsp.nvim"

    -- elixir
    use "mhanberg/elixir.nvim"

    -- dart
    use "dart-lang/dart-vim-plugin"

    -- flutter
    use "akinsho/flutter-tools.nvim"
    use "Nash0x7E2/awesome-flutter-snippets" -- for LuaSnip

    -- js and ts
    use "pangloss/vim-javascript"
    use "peitalin/vim-jsx-typescript"
    use "leafgarland/typescript-vim"

    -- hrsh7th's nvim lsp plugins
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lsp-document-symbol"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "hrsh7th/cmp-nvim-lua" -- lua support
    use "hrsh7th/cmp-path"
    use "f3fora/cmp-spell"

    -- 3rd party hrsh7th's plugins
    use "ray-x/cmp-treesitter"
    use "saadparwaiz1/cmp_luasnip" -- snippets required for hrsh7th's plugins
    use "tamago324/cmp-zsh"
    use "uga-rosa/cmp-dictionary"
end)
