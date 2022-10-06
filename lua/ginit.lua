-- FIXME `set_font` can only be called once in the init process
-- if not it would give errors and you can only use it once nvim
-- is started
FontName = "Iosevka"
FontSize = 16

function SetFont(name, size)
    FontName = name
    FontSize = size

    if tonumber(FontSize) <= 1 then
        FontSize = 1
    end

	if vim.fn.exists(":GuiFont") ~= 0 then
		vim.api.nvim_command("GuiFont! " .. FontName .. ":h" .. FontSize)
	end

    -- TODO Add support for other Neovim GUIs here
end
vim.api.nvim_create_user_command("SetFont", "lua SetFont(<f-args>)", { nargs = "*" })

function ShowFont()
    require("notify").notify("Font: " .. FontName .. ":" .. FontSize)
end
vim.api.nvim_create_user_command("ShowFont", "lua ShowFont()", {})
vim.api.nvim_set_keymap("n", "<leader>ff", ":ShowFont<CR>", {noremap = true, silent = true})

function ChangeFont(name)
    SetFont(name, FontSize)
end

function ChangeFontSize(size)
    SetFont(FontName, size)
end

function IncreaseFontSize()
    ChangeFontSize(FontSize + 1)
end

function DecreaseFontSize()
    ChangeFontSize(FontSize - 1)
end

vim.api.nvim_set_keymap("n", "<C-=>", ":lua IncreaseFontSize()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-+>", ":lua IncreaseFontSize()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-->", ":lua DecreaseFontSize()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-_>", ":lua DecreaseFontSize()<CR>", {noremap = true, silent = true})

-- call `SetFont` from the ginit_local.lua file to use your favorite font

if vim.fn.exists(":GuiTabline") ~= 0 then
    vim.api.nvim_command("GuiTabline 0")
end

if vim.fn.exists(":GuiPopupmenu") ~= 0 then
    vim.api.nvim_command("GuiPopupmenu 0")

    vim.api.nvim_set_keymap('n', '<RightMouse>', ":call GuiShowContextMenu()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('i', '<RightMouse>', "<Esc>:call GuiShowContextMenu()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('x', '<RightMouse>', ":call GuiShowContextMenu()<CR>gv", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('s', '<RightMouse>', "<C-G>:call GuiShowContextMenu()<CR>gv", { noremap = true, silent = true })
end

if vim.fn.exists(":GuiScrollBar") ~= 0 then
    vim.api.nvim_command("GuiScrollBar 0")
end
