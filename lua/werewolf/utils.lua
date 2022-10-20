----------------------
--- Werewolf Utils ---
----------------------

local Utils = {}

--- Returns the OS name
-- @return string: 'Darwin' | 'Windows' | 'Linux'
Utils.os_uname = vim.loop.os_uname().sysname

Utils.default_theme_handlers = {
  --- Returns the OS theme using default handlers for each OS
  -- @return string: 'light' | 'dark'
  system = {
    Darwin = function(update_appearance)
      local command, result

      command = "defaults read -g AppleInterfaceStyle 2>/dev/null"
      result = vim.fn.system(command):gsub("%s", "")

      if result == "Dark" then
        update_appearance("dark")
      else
        update_appearance("light")
      end
    end,
  },

  -- Use a fixed hour schedule to set the theme
  -- @param table indicating the default time window to use the light theme
  -- @return 'light' or 'dark'
  fixed_hours = function(day_time, update_appearance)
    local time = tonumber(os.date("%H"))

    if time >= day_time.from and time < day_time.to then
      update_appearance("light")
    else
      update_appearance("dark")
    end
  end,
}

return Utils
