return require("packer").startup(function()
	use "igorgue/danger" -- danger colorscheme
	use "wbthomason/packer.nvim" -- packer update itself
    use { -- nice interface for LSP functions (among other things)
        "nvim-telescope/telescope.nvim",
        requires = { {"nvim-lua/plenary.nvim"} }
    }
    use "neovim/nvim-lspconfig" -- native LSP support
    use "L3MON4D3/LuaSnip" -- Lua based snippets
    use "onsails/lspkind.nvim"

    -- mattn's pluggins
    use "mattn/gist-vim"
    use "mattn/webapi-vim"
    use "mhinz/vim-startify"

    -- oldies
	use "preservim/nerdcommenter" -- comment and uncomment
    use "preservim/tagbar"

    -- tpope
	use "tpope/vim-sensible" -- sensible default vim settings by tpope
	use "tpope/vim-surround" -- wrap objects with text
    use "tpope/vim-git"
    use "tpope/vim-fugitive"

    -- light theme
    use "sainnhe/edge"

    -- kyazdani42's plugins
    use "kyazdani42/nvim-web-devicons"
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use "neovim/nvim-lspconfig"
    use "norcalli/nvim-colorizer.lua"
    use {
        "numirias/semshi", {run = ":UpdateRemotePlugins"}
    }
    use "nvim-lua/plenary.nvim"
    use "nvim-telescope/telescope.nvim"
    use {
        "nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"}
    }
    use "p00f/nvim-ts-rainbow"
    use "lewis6991/gitsigns.nvim"

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

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
