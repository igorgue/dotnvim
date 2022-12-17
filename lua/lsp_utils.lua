local M = {}

vim.g.show_diagnostics = true

x = 10

M.diagnostic_config = {
    float = { border = "rounded" },
    underline = true,
    virtual_text = {
        spacing = 0,
        prefix = "",
    },
    signs = true,
    update_in_insert = true,
    severity_sort = true,
}

-- toggle diagnostics
-- as expressed in :h vim.lsp.codelens.refresh
function M.diagnostics_toggle()
    vim.g.show_diagnostics = not vim.g.show_diagnostics

    if vim.g.show_diagnostics then
        vim.diagnostic.enable(0)
    else
        vim.diagnostic.disable(0)
    end
end

function M.on_attach(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local sagaopts = { silent = true }
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-\\>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>r", vim.lsp.codelens.run, bufopts)

    -- lsp saga
    vim.keymap.set("n", "<leader>2", "<cmd>Lspsaga outline<CR>", sagaopts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", sagaopts)
    vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", sagaopts)
    vim.keymap.set("n", "<leader>cd", "<cmp>Lspsaga peek_definition<CR>", sagaopts)
    vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", sagaopts)
    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", sagaopts)
    vim.keymap.set("n", "<leader>ck", "<cmd>Lspsaga hover_doc<CR>", sagaopts)
    vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)
    vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)
    vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga show_line_diagnostics<CR>", sagaopts)

    -- telescope
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts)
    vim.keymap.set("n", "<leader>e", M.diagnostics_toggle, bufopts)

    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
end

M.capabilities = vim.tbl_deep_extend(
    "force",
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    {
        textDocument = {
            completion = {
                editsNearCursor = true,
                completionItem = {
                    snippetSupport = true,
                },
            },
        },
        offsetEncoding = "utf-8",
    }
)

return M
