-- VSCode has a smaller configuration since it does all the file managing and lsp for you
if vim.g.vscode then
    require("vscode_plugins")
    require("vscode") -- vscode only settings

    -- vscode local settings
    if vim.api.nvim_get_runtime_file("lua/vscode_local.lua", false)[1] then
        require("vscode_local")
    end

    -- exit early to prevent launching all the rest of the config that vscode don't care about
    do
        return
    end
end

-- there might be errors likely related to missing colorscheme and / or plugins
if not pcall(function()
    require("pre_init")
end) then
    print("Unable to load pre_init, likely you're calling a plugin, missing or broken.")
end

require("plugins")
require("settings")

-- Load final overrites or local settings
if vim.api.nvim_get_runtime_file("lua/init_local.lua", false)[1] then
    require("init_local")
end

-- Load ginit.lua only for UI
vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        require("ginit")

        -- Load ginit_local.lua for local UI changes, font for example
        if vim.api.nvim_get_runtime_file("lua/ginit_local.lua", false)[1] then
            require("ginit_local")
        end
    end,
})
