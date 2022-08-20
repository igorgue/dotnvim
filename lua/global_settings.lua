vim.api.nvim_set_var("mapleader", ",") -- map leader to ,

vim.api.nvim_create_user_command("W", "w", {}) -- make :W == :w

-- mappings
vim.keymap.set("n", "<leader>3", ":noh<CR>") -- ,4 to clear search results
vim.keymap.set("n", "<leader>l", ":set list!<CR>") -- ,l to show invisibles

-- movement without the extra ctrl+w
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {})

vim.api.nvim_set_keymap('n', ';', ':', {noremap = true}) -- ; to :

-- options
vim.opt.startofline = false -- reopen on same line
vim.opt.sm = true -- substitute with magic
vim.opt.hlsearch = true -- search
vim.opt.incsearch = true -- incremental
vim.opt.ignorecase = true -- ignoring case
vim.opt.smartcase = true -- with smartness
vim.opt.wildignorecase = true -- and with wildcard ignore case
