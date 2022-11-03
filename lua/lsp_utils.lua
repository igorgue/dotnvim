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

function M.on_attach(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-\\>", vim.lsp.buf.signature_help, bufopts) -- replaced by signature.nvim
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts) -- replaced by lspsaga
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<leader>r", vim.lsp.codelens.run, bufopts)

    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

return M
