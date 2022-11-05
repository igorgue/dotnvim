-- some utils
local M = {}

vim.g.default_font_name = "Monospace"
vim.g.default_font_size = 14

vim.g.font_name = vim.g.default_font_name
vim.g.font_size = vim.g.default_font_size
vim.g.font_set_by_user = false

-- show syntax highlighting group useful for theme development
function M.syn_stack()
    vim.cmd([[
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    ]])
end

function M.hi_co(group, kind)
    return vim.fn.synIDattr(vim.fn.hlID(group), kind)
end

-- FIXME: `set_font` can only be called once in the init process
-- if not it would give errors and you can only use it once nvim
-- is started
function M.set_font(name, size)
    -- only supports nvim-qt
    if vim.fn.exists(":GuiFont") == 0 then
        return
    end

    vim.g.font_name = name
    vim.g.font_size = size

    if tonumber(vim.g.font_size) <= 1 then
        vim.g.font_size = 1
    end

    -- show notification if font is set by user after initial startup
    vim.api.nvim_command("GuiFont! " .. vim.g.font_name .. ":h" .. vim.g.font_size)
    if vim.g.font_set_by_user then
        vim.api.nvim_command("ShowFont")
    else
        vim.g.font_set_by_user = true
    end
end

function M.show_font()
    vim.notify("Font: " .. vim.g.font_name .. ":" .. vim.g.font_size)
end

function M.change_font(name)
    M.set_font(name, vim.g.font_size)
end

function M.change_font_size(size)
    M.set_font(vim.g.font_name, size)
end

function M.increase_font_size()
    M.change_font_size(vim.g.font_size + 1)
end

function M.decrease_font_size()
    M.change_font_size(vim.g.font_size - 1)
end

function M.default_font()
    M.set_font(vim.g.default_font_name, vim.g.default_font_size)
end

function M.lualine_theme()
    local lualine_colors = {
        black = M.hi_co("Normal", "bg"),
        white = M.hi_co("Normal", "fg"),
        red = M.hi_co("ErrorMsg", "fg"),
        green = M.hi_co("Label", "fg"),
        blue = M.hi_co("CursorLineNr", "fg"),
        yellow = M.hi_co("Function", "fg"),
        gray = M.hi_co("PMenu", "fg"),
        darkgray = M.hi_co("LspCodeLens", "fg"),
        lightgray = M.hi_co("Visual", "bg"),
        inactivegray = M.hi_co("TabLine", "fg"),
    }

    return {
        normal = {
            a = { bg = lualine_colors.gray, fg = lualine_colors.black, gui = "bold" },
            b = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
            c = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
        },
        insert = {
            a = { bg = lualine_colors.blue, fg = lualine_colors.black, gui = "bold" },
            b = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
            c = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
        },
        visual = {
            a = { bg = lualine_colors.yellow, fg = lualine_colors.black, gui = "bold" },
            b = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
            c = { bg = lualine_colors.inactivegray, fg = lualine_colors.black },
        },
        replace = {
            a = { bg = lualine_colors.red, fg = lualine_colors.black, gui = "bold" },
            b = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
            c = { bg = lualine_colors.black, fg = lualine_colors.white },
        },
        command = {
            a = { bg = lualine_colors.green, fg = lualine_colors.black, gui = "bold" },
            b = { bg = lualine_colors.lightgray, fg = lualine_colors.white },
            c = { bg = lualine_colors.inactivegray, fg = lualine_colors.black },
        },
        inactive = {
            a = { bg = lualine_colors.darkgray, fg = lualine_colors.gray, gui = "bold" },
            b = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
            c = { bg = lualine_colors.darkgray, fg = lualine_colors.gray },
        },
    }
end

function M.lualine_setup_options()
    local theme = M.lualine_theme() or "auto"

    return {
        options = {
            theme = theme,
            component_separators = "",
            section_separators = { left = "", right = "" },
            globalstatus = true,
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    separator = { left = "" },
                    fmt = function(str)
                        return str:lower():sub(1, 1)
                    end,
                },
            },
            lualine_b = { "branch", "diff", { "diagnostics", update_in_insert = true } },
            lualine_c = {
                {
                    "filename",
                    padding = 1,
                    path = 1,
                    symbols = { modified = "", readonly = "", new = "", unnamed = "" },
                },
            },
            lualine_x = {
                {
                    require("noice").api.status.mode.get,
                    cond = require("noice").api.status.mode.has,
                },
                "encoding",
                { "filetype", icon_only = true },
                "fileformat",
            },
            lualine_y = { "location" },
            lualine_z = {
                { "progress", separator = { right = "" } },
            },
        },
    }
end

function M.setup_tabline()
    -- sets tabline without the "X" for close, this is done for aesthetic reasons
    -- and this code is copied from :h setting-tabline
    vim.cmd([[
        function NoXTabLine()
            let s = ''
            for i in range(tabpagenr('$'))
                " select the highlighting
                if i + 1 == tabpagenr()
                    let s ..= '%#TabLineSel#'
                else
                    let s ..= '%#TabLine#'
                endif

                " set the tab page number (for mouse clicks)
                let s ..= '%' .. (i + 1) .. 'T'

                " the label is made by NoXTabLabel()
                let s ..= ' %{NoXTabLabel(' .. (i + 1) .. ')} '
            endfor

            " after the last tab fill with TabLineFill and reset tab page nr
            let s ..= '%#TabLineFill#%T'

            " right-align the label to close the current tab page
            if tabpagenr('$') > 1
                " Does not include the close button
                let s ..= '%=%#TabLine#%999X'
            endif

            return s
        endfunction

        function NoXTabLabel(n)
            let buflist = tabpagebuflist(a:n)
            let winnr = tabpagewinnr(a:n)
            let name = bufname(buflist[winnr - 1])

            " Modification for no name...
            if name == ''
                return '[No Name]'
            endif

            return name
        endfunction

        set tabline=%!NoXTabLine()
    ]])
end

function M.alpha_theme()
    local theme = require("alpha.themes.theta")
    local dashboard = require("alpha.themes.dashboard")
    local neovim_version = vim.version()

    local version = neovim_version.major .. "." .. neovim_version.minor .. "." .. neovim_version.patch
    if neovim_version.prerelease then
        version = version .. "-dev"
    end

    theme.header.val = { "neovim v" .. version }

    theme.config.layout[4].val[1].val = "recent"
    theme.buttons.val = {
        { type = "text", val = "shortcuts", opts = { hl = "specialcomment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("e", "  new file", "<cmd>ene<cr>"),
        dashboard.button("space n", "  find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("space P", "  live grep", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("c", "  configuration", "<cmd>Conf<cr><cmd>ConfSettings<cr>"),
        dashboard.button("u", "  update plugins", "<cmd>PackerSync<cr>"),
        dashboard.button("q", "  quit", "<cmd>qa<cr>"),
    }

    return theme
end

return M
