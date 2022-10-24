-- some utils
local M = {}

vim.g.default_font_name = "Monospace"
vim.g.default_font_size = 14

vim.g.font_name = vim.g.default_font_name
vim.g.font_size = vim.g.default_font_size
vim.g.font_set_by_user = false

-- show syntax highlighting group useful for theme development
function M.SynStack()
    vim.cmd([[
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    ]])
end

function M.HiCo(group, kind)
    return vim.fn.synIDattr(vim.fn.hlID(group), kind)
end

-- FIXME `set_font` can only be called once in the init process
-- if not it would give errors and you can only use it once nvim
-- is started
function M.SetFont(name, size)
    vim.g.font_name = name
    vim.g.font_size = size

    if tonumber(vim.g.font_size) <= 1 then
        vim.g.font_size = 1
    end

    if vim.fn.exists(":GuiFont") ~= 0 then
        vim.api.nvim_command("GuiFont! " .. vim.g.font_name .. ":h" .. vim.g.font_size)
    end

    -- TODO Add support for other Neovim GUIs here

    -- show notification if font is set by user after initial startup
    if vim.g.font_set_by_user then
        vim.api.nvim_command("ShowFont")
    else
        vim.g.font_set_by_user = true
    end
end

function M.ShowFont()
    require("notify").notify("Font: " .. vim.g.font_name .. ":" .. vim.g.font_size)
end

function M.ChangeFont(name)
    M.SetFont(name, vim.g.font_size)
end

function M.ChangeFontSize(size)
    M.SetFont(vim.g.font_name, size)
end

function M.IncreaseFontSize()
    M.ChangeFontSize(vim.g.font_size + 1)
end

function M.DecreaseFontSize()
    M.ChangeFontSize(vim.g.font_size - 1)
end

function M.DefaultFont()
    M.SetFont(vim.g.default_font_name, vim.g.default_font_size)
end


return M
