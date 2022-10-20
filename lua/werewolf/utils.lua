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
    Darwin = function(update_appearance, run_opts)
      local command = "defaults read -g AppleInterfaceStyle 2>/dev/null" -- Returns "Dark\n" or ""
      -- may need to check AppleInterfaceStyleSwitchesAutomatically too
      -- or to run this first: "osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to not dark mode'"
      -- useful info on osascript: https://scriptingosx.com/2020/09/avoiding-applescript-security-and-privacy-requests/

      -- Callback to update appearance on command stdout
      local cb = function(command_output)
        local result = command_output:gsub("%s", "")
        if result == "Dark" then
          update_appearance("dark")
        else
          update_appearance("light")
        end
      end

      if run_opts.sync then
        -- run command synchronously (useful on startup)
        cb(vim.fn.system(command))
      else
        -- run command asynchronously (default behaviour)
        vim.fn.jobstart(command, {
          on_stdout = function(_, data, _)
            -- vim.pretty_print({ j = j, d = data, e = e })
            cb(data[1] or "")
          end,
          stdout_buffered = true,
        })
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
