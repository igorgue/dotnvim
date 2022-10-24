local M = {}

vim.g.show_diagnostics = true

-- toggle diagnostics
-- as expressed in :h vim.lsp.codelens.refresh
function M.diagnostics_toggle()
    vim.g.show_diagnostics = not vim.g.show_diagnostics

    if vim.g.show_diagnostics then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end

return M
