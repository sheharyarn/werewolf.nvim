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
    local command = 'defaults read -g AppleInterfaceStyle 2>/dev/null'
    local result = Utils.run_command(command):gsub('%s', '')

    if result == 'Dark' then
      return 'Dark'
    else
      return 'Light'
    end
  end,

  Linux = function()
    -- Freedesktop portal doc
    -- https://github.com/flatpak/xdg-desktop-portal/blob/d7a304a00697d7d608821253cd013f3b97ac0fb6/data/org.freedesktop.impl.portal.Settings.xml#L33-L45
    if vim.fn.executable("gdbus") then
      local command = [[gdbus call --session --timeout=1000 \
                        --dest=org.freedesktop.portal.Desktop \
                        --object-path /org/freedesktop/portal/desktop \
                        --method org.freedesktop.portal.Settings.Read org.freedesktop.appearance color-scheme 2>&1]]
      local result = Utils.run_command(command)
      if string.find(result, "(<<uint32 1>>,)") ~= nil then
        return "Dark"
      end
    end

    -- We didn't find gdbus or the command failed so assume light mode
    return "Light"
  end
}

Utils.get_theme = function()
  local os = Utils.get_os()
  local handler = default_theme_handlers[os]

  if type(handler) == 'function' then
    return handler()
  else
    print('[ERROR] Could not fetch system theme!')
  end
end



return Utils
