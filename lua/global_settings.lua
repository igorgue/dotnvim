local opts = { silent = true }

-- mappings
vim.keymap.set("n", "<leader>3", ":noh<CR>", opts) -- <leader>3 to clear search results

-- movement without the extra ctrl+w
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", opts)
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", opts)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", opts)

-- vim.api.nvim_set_keymap("n", ";", ":", {}) -- ; to : miss some features but faster

-- options
vim.opt.startofline = false -- reopen at the start of line
vim.opt.sm = true -- substitute with magic
vim.opt.hlsearch = true -- search
vim.opt.incsearch = true -- incremental
vim.opt.ignorecase = true -- ignoring case
vim.opt.smartcase = false -- with smartness
vim.opt.wildignorecase = true -- and with wildcard ignore case
