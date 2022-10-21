-- some utils
-- show syntax highlighting group useful for theme development
function SynStack()
    vim.cmd([[
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    ]])
end
vim.api.nvim_set_keymap("n", "<leader>x", ":TSHighlightCapturesUnderCursor<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>xx", ":lua SynStack()<CR>", {})

function HiCo(group, kind)
    return vim.fn.synIDattr(vim.fn.hlID(group), kind)
end

vim.g.fg = HiCo("Normal", "fg")
vim.g.bg = HiCo("Normal", "bg")
