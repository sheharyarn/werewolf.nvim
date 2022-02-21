---------------------
--- Werewolf.nvim ---
---------------------

local Utils = require('utils')
local Werewolf = {}



-- Default configuration for Werewolf
local DEFAULT_OPTS = {
  system_theme = {
    get = Utils.get_theme,
    on_change = nil,
    run_on_start = true,
    period = 500,
  },
}



-- User configuration currently loaded
--local user_opts = DEFAULT_OPTS
local current_theme = nil

local user_opts = {
  system_theme = {
    on_change = function(theme)
      vim.o.background = theme

      if theme == 'Dark' then
        vim.g.material_style = 'deep ocean'
        vim.cmd('colorscheme material')
        print('Dark theme set!')
      else
        vim.g.material_style = 'lighter'
        vim.cmd('colorscheme material')
        print('Light theme set!')
      end
    end,

    period = 200,
  },
}



--- Setup and start Werewolf with the provided config
-- @param opts table: Config for Werewolf
-- @return nil
Werewolf.setup = function(opts)
  -- Merge user options with default config
  -- user_opts = vim.tbl_deep_extend('force', DEFAULT_OPTS, opts || {})
  user_opts = vim.tbl_deep_extend('force', DEFAULT_OPTS, user_opts || {})

  -- Track the current theme
  current_theme = user_opts.system_theme.get()

  -- Run on start if enabled
  if user_opts.system_theme.run_on_start then
    Werewolf.run(true)
  end

  -- Start execution loop using vim.loop timer
  local timer = vim.loop.new_timer()
  local period = user_opts.system_theme.period

  timer:start(period, period, vim.schedule_wrap(Werewolf.run))
end



--- Runs Werewolf manually, applying any configurations based
-- on the system theme
-- @param force boolean: Run even if theme did not change
-- @return nil
Werewolf.run = function(force)
  if type(user_opts.on_change) == 'function' then
    local new_theme = user_opts.system_theme.get()

    -- Apply user method if theme changes or forced
    if (force) or (new_theme ~= current_theme) then
      current_theme = new_theme
      user_opts.on_change(current_theme)
    end
  end
end



return Werewolf;
