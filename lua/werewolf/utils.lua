----------------------
--- Werewolf Utils ---
----------------------

local Utils = {}

--- Returns the OS name
-- @return string: 'Darwin' | 'Windows' | 'Linux'
local os_uname = vim.loop.os_uname().sysname

local default_theme_handlers = {
  --- Returns the OS theme using default handlers for each OS
  -- @return string: 'light' | 'dark'
  system = {
    Darwin = function()
      local command, result

      command = "defaults read -g AppleInterfaceStyle 2>/dev/null"
      result = vim.fn.system(command):gsub("%s", "")

      if result == "Dark" then
        return "dark"
      else
        return "light"
      end
    end,
  },

  -- Use a fixed hour schedule to set the theme
  -- @param table indicating the default time window to use the light theme
  -- @return 'light' or 'dark'
  fixed_hours = function(day_time)
    local time = tonumber(os.date("%H"))

    if time >= day_time.from and time < day_time.to then
      return "light"
    else
      return "dark"
    end
  end,
}

Utils.get_theme = function(mode, day_time)
  local handler = nil

  if mode == "system" and os_uname == "Darwin" then
    handler = default_theme_handlers["system"][os_uname]
    return handler()
  else
    -- mode == "fixed_hours" is the fallback
    handler = default_theme_handlers["fixed_hours"]
    return handler(day_time)
  end
end

return Utils
