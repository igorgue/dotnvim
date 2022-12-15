vim.opt.encoding = "utf-8"

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_set_var("mapleader", " ") -- map leader to " " (space)

if vim.api.nvim_get_runtime_file("lua/pre_init_local.lua", false)[1] then
    require("pre_init_local")
end
