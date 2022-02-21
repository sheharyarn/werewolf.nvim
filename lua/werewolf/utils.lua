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
