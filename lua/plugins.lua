return require("packer").startup(function()
	use "igorgue/danger" -- danger colorscheme
	use "tpope/vim-sensible" -- sensible default vim settings by tpope
	use "wbthomason/packer.nvim" -- packer update itself
    use { -- nice interface for LSP functions (among other things)
        "nvim-telescope/telescope.nvim",
        requires = { {"nvim-lua/plenary.nvim"} }
    }
    use "neovim/nvim-lspconfig" -- native LSP support
    use "L3MON4D3/LuaSnip" -- Lua based snippets

    -- hrsh7th's nvim lsp plugins
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "saadparwaiz1/cmp_luasnip" -- snippets required for hrsh7th's plugins
    use "hrsh7th/cmp-nvim-lua" -- lua support
    use "hrsh7th/cmp-nvim-lsp-document-symbol"
    use "ray-x/cmp-treesitter"
end)
