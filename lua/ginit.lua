-- FIXME `set_font` can only be called once in the init process
-- if not it would give errors and you can only use it once nvim
-- is started
vim.g.default_font_name = "Monospace"
vim.g.default_font_size = 14

vim.g.font_name = vim.g.default_font_name
vim.g.font_size = vim.g.default_font_size
vim.g.font_set_by_user = false

function SetFont(name, size)
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
vim.api.nvim_create_user_command("SetFont", function(opts)
    SetFont(unpack(opts.fargs))
end, { nargs = "*" })

function ShowFont()
    require("notify").notify("Font: " .. vim.g.font_name .. ":" .. vim.g.font_size)
end
vim.api.nvim_create_user_command("ShowFont", ShowFont, { nargs = "*" })

function ChangeFont(name)
    SetFont(name, vim.g.font_size)
end

function ChangeFontSize(size)
    SetFont(vim.g.font_name, size)
end

function IncreaseFontSize()
    ChangeFontSize(vim.g.font_size + 1)
end

function DecreaseFontSize()
    ChangeFontSize(vim.g.font_size - 1)
end

function DefaultFont()
    SetFont(vim.g.default_font_name, vim.g.default_font_size)
end

vim.api.nvim_create_user_command("DefaultFont", "lua DefaultFont()", {})
vim.api.nvim_set_keymap("n", "<C-0>", ":DefaultFont<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-=>", ":lua IncreaseFontSize()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-+>", ":lua IncreaseFontSize()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-->", ":lua DecreaseFontSize()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-_>", ":lua DecreaseFontSize()<CR>", { noremap = true, silent = true })

-- call `SetFont` from the ginit_local.lua file to use your favorite font

if vim.fn.exists(":GuiTabline") ~= 0 then
    vim.api.nvim_command("GuiTabline 0")
end

if vim.fn.exists(":GuiPopupmenu") ~= 0 then
    vim.api.nvim_command("GuiPopupmenu 0")
end

if vim.fn.exists(":GuiShowContextMenu") ~= 0 then
    vim.api.nvim_set_keymap("n", "<RightMouse>", ":call GuiShowContextMenu()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
        "i",
        "<RightMouse>",
        "<Esc>:call GuiShowContextMenu()<CR>",
        { noremap = true, silent = true }
    )
    vim.api.nvim_set_keymap("x", "<RightMouse>", ":call GuiShowContextMenu()<CR>gv", { noremap = true, silent = true })
    vim.api.nvim_set_keymap(
        "s",
        "<RightMouse>",
        "<C-G>:call GuiShowContextMenu()<CR>gv",
        { noremap = true, silent = true }
    )
end

if vim.fn.exists(":GuiScrollBar") ~= 0 then
    vim.api.nvim_command("GuiScrollBar 0")
end
