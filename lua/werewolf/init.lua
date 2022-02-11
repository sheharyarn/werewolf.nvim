---------------------
--- Werewolf.nvim ---
---------------------

MACOS_COMMAND = 'defaults read -g AppleInterfaceStyle 2>/dev/null'

sleep = function()
  os.execute("sleep " .. tonumber(1))
end

get_theme = function()
  local type = vim.fn.system(MACOS_COMMAND)
  type = type:gsub('%s+', '');

  if type == 'Dark' then
    return 'dark'
  else
    return 'light'
  end
end

get_theme = function()
  local handle = io.popen(MACOS_COMMAND)
  local result = handle:read("*a")
  handle:close()
  result = result:gsub('%s+', '')

  if result == 'Dark' then
    return 'dark'
  else
    return 'light'
  end
end

on_change = function(theme)
  vim.o.background = theme

  if theme == 'dark' then
    vim.g.material_style = 'deep ocean'
    vim.cmd('colorscheme material')
    print('Dark theme set!')
  else
    vim.g.material_style = 'lighter'
    vim.cmd('colorscheme material')
    print('Light theme set!')
  end
end
on_start = on_change
--on_change=nil

-- Create a timer handle (implementation detail: uv_timer_t).
local timer = vim.loop.new_timer()
local i = 0

local prev_theme = get_theme()
print('Initial Theme: '..prev_theme)

-- Waits 200ms, then repeats every 1000ms until timer:close().
timer:start(200, 500, vim.schedule_wrap(function()
  if type(on_change) == 'function' then
    local current_theme = get_theme()

    if prev_theme == current_theme then
      --
      --print('Theme unchanged')
    else
      prev_theme = current_theme
      on_change(current_theme)
      --print('Theme changed to '..current_theme)
    end
  else
    --
    print('on_change not a function')
  end
end))
