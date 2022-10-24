local M = {}

function M.edit_dbs_config()
    vim.cmd("e ~/.config/nvim/lua/dbs_local.lua")
end

function M.cd_conf()
    vim.cmd("cd ~/.config/nvim")
end

function M.edit_conf()
    M.cd_conf()
    vim.cmd("e init.lua")
end

return M
