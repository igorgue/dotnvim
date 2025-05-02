local M = {}

M.ui = require("utils.ui")

function M.version()
  local ver = vim.version()

  return ver.major .. "." .. ver.minor .. "." .. ver.patch
end

function M.linux_os_info()
  local function parse_release_file(path, keys)
    local info = {}
    local f = io.open(path, "r")
    if not f then
      return nil
    end
    for line in f:lines() do
      -- Match key=value (quoted or unquoted)
      local k, v = line:match('^(%w+)%s*=%s*"(.-)"$')
      if not k then
        k, v = line:match("^(%w+)%s*=%s*(.+)$")
      end
      if k and v and keys[k] then
        info[k] = v
      end
    end
    f:close()
    return info
  end

  local os_info = parse_release_file("/etc/os-release", { NAME = true, VERSION = true })
  if os_info and os_info.NAME then
    if os_info.VERSION then
      return os_info.NAME .. " " .. os_info.VERSION
    else
      return os_info.NAME
    end
  end

  local lsb_info = parse_release_file("/etc/lsb-release", {
    DISTRIB_DESCRIPTION = true,
    DISTRIB_ID = true,
    DISTRIB_RELEASE = true,
  })
  if lsb_info then
    if lsb_info.DISTRIB_DESCRIPTION then
      return lsb_info.DISTRIB_DESCRIPTION
    elseif lsb_info.DISTRIB_ID and lsb_info.DISTRIB_RELEASE then
      return lsb_info.DISTRIB_ID .. " " .. lsb_info.DISTRIB_RELEASE
    elseif lsb_info.DISTRIB_ID then
      return lsb_info.DISTRIB_ID
    end
  end

  return "Linux (unknown version)"
end

function M.desktop_environment_info()
  -- Try to detect the desktop environment or window manager
  local xdg_desktop = os.getenv("XDG_CURRENT_DESKTOP")
  local xdg_session = os.getenv("XDG_SESSION_DESKTOP")
  local wayland_session = os.getenv("WAYLAND_DISPLAY")
  local hyprland_env = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")

  if hyprland_env or (xdg_desktop and xdg_desktop:lower():find("hypr")) then
    return "Hyprland"
  elseif xdg_desktop then
    return xdg_desktop
  elseif xdg_session then
    return xdg_session
  elseif wayland_session then
    return "Wayland (unknown compositor)"
  else
    return "Unknown DE/WM"
  end
end

function M.file_info()
  local path = vim.fn.expand("%:~:.")
  local filename = vim.fn.expand("%:t")
  local cursor = vim.fn.line(".") .. ":" .. vim.fn.col(".")
  local lines = vim.fn.line("$")

  M.ui.refresh_ui()

  if #path > 50 then
    vim.notify('"' .. path .. '"' .. "\n" .. cursor .. " " .. lines .. " lines", vim.log.levels.INFO, {
      title = filename,
    })
  else
    vim.notify('"' .. path .. '"' .. " @ " .. cursor .. " " .. lines .. " lines", vim.log.levels.INFO, {
      title = filename,
    })
  end
end

return M
