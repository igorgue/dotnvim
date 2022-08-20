return require("packer").startup(function()
	use "michaeljsmith/vim-indent-object"	-- selection of indentation blocks
	use "preservim/nerdcommenter"		-- comment and uncomment
	use "tpope/vim-sensible"		-- sensible default vim settings
	use "tpope/vim-surround"		-- wrap objects with text
end)
