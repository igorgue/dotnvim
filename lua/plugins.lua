return require("packer").startup(function()
	use "igorgue/danger" -- danger colorscheme
	use "wbthomason/packer.nvim" -- packer update itself
    use { -- nice interface for LSP functions (among other things)
        "nvim-telescope/telescope.nvim",
        requires = { {"nvim-lua/plenary.nvim"} }
    }
    use "neovim/nvim-lspconfig" -- native LSP support
    use "L3MON4D3/LuaSnip" -- Lua based snippets
    use "onsails/lspkind.nvim" -- Nice kinds on lsp menus

    -- mattn's pluggins
    use "mattn/gist-vim" -- submit a gist
    use "mattn/webapi-vim" -- requirement for gist
    use "mhinz/vim-startify" -- shows a nice startup page

    -- oldies
	use "preservim/nerdcommenter" -- comment and uncomment
    use "preservim/tagbar" -- show a tagbar from the ctags

    -- tpope
	use "tpope/vim-sensible" -- sensible default vim settings by tpope
	use "tpope/vim-surround" -- wrap objects with text
    use "tpope/vim-git" -- git stuff from tpope
    use "tpope/vim-fugitive" -- more git stuff

    use "sainnhe/edge" -- light theme

    use 'sheerun/vim-polyglot' -- syntax hi collection

    -- kyazdani42's plugins
    use "kyazdani42/nvim-web-devicons" -- devicons
    use {
        'kyazdani42/nvim-tree.lua', -- a file manager
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use "neovim/nvim-lspconfig" -- lsp config for neovim
    use "norcalli/nvim-colorizer.lua" -- colors
    use {
        "numirias/semshi", {run = ":UpdateRemotePlugins"} -- colors for Python
    }
    use "nvim-lua/plenary.nvim" -- dunno...
    use "nvim-telescope/telescope.nvim" -- Opens files and stuff
    use {
        "nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"}
    }
    use "p00f/nvim-ts-rainbow" -- shows rainbow matching braces
    use "lewis6991/gitsigns.nvim" -- changes on git

    -- lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- js and ts
    use "pangloss/vim-javascript"
    use "peitalin/vim-jsx-typescript"
    use "leafgarland/typescript-vim"

    -- hrsh7th's nvim lsp plugins
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-calc"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lsp-document-symbol"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "hrsh7th/cmp-nvim-lua" -- lua support
    use "hrsh7th/cmp-path"
    use "hrsh7th/nvim-cmp"
    use "f3fora/cmp-spell"

    -- 3rd party hrsh7th's plugins
    use "ray-x/cmp-treesitter"
    use "saadparwaiz1/cmp_luasnip" -- snippets required for hrsh7th"s plugins
    use "tamago324/cmp-zsh"
    use "uga-rosa/cmp-dictionary"
end)
