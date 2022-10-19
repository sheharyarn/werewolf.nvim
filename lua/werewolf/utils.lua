----------------------
--- Werewolf Utils ---
----------------------

local Utils = {}

--- Returns the OS name
-- @return string: 'Darwin' | 'Windows' | 'Linux'
Utils.get_os = function()
  return vim.loop.os_uname().sysname
end

--- Run a system command and return the output
-- @param  command string: Command to execute
-- @return string: STDOUT result
Utils.run_command = function(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()

  return result
end

--- Returns the OS theme using default handlers for each OS
-- @return string: 'Light' | 'Dark'

local default_theme_handlers = {
  -- Default implmentation for macOS
  Darwin = function()
    local command = "defaults read -g AppleInterfaceStyle 2>/dev/null"
    local result = Utils.run_command(command):gsub("%s", "")

    if result == "Dark" then
      return "dark"
    else
      return "light"
    end
  end,

  -- Use a fixed hour schedule to set the theme
  -- @param table indicating the default time window to use the light theme
  -- @return 'Light' or 'Dark'
  fixed_hours = function(day_time)
    local time = tonumber(os.date("%H"))

    if time >= day_time.from and time < day_time.to then
      return "light"
    else
      return "dark"
    end
  end,
}

local is_macos = vim.fn.has("mac")

Utils.get_theme = function(mode, day_time)
  local handler = nil

  if mode == "system" and is_macos then
    local os = Utils.get_os()
    handler = default_theme_handlers[os]
    if type(handler) == "function" then
      return handler()
    else
      print("[ERROR] Could not fetch system theme!")
    end
  else -- elseif mode == 'fixed_hours' then
    handler = default_theme_handlers["fixed_hours"]
    return handler(day_time)
    -- else
    --   print("[ERROR] Unsupported mode!")
  end
end

return Utils
