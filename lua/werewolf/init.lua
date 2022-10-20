---------------------
--- Werewolf.nvim ---
---------------------

local Utils = require("werewolf.utils")
local Werewolf = {}

-- Default configuration for Werewolf
local DEFAULT_OPTS = {
  on_change = nil,
  run_on_start = true,
  period = 500,
  mode = "system",
  day_time = { from = 8, to = 20 },
}

-- User configuration currently loaded
local user_opts = DEFAULT_OPTS
local state = {
  appearance = nil, -- 'dark' | 'light'
}
local update_appearance = nil

--- Return the werewolf config currently set
-- @return table: Current Werewolf config
Werewolf.config = function()
  return user_opts
end

--- Setup and start Werewolf with the provided config
-- @param opts table: Config for Werewolf
-- @return nil
Werewolf.setup = function(opts)
  -- Merge user options with default config
  user_opts = vim.tbl_deep_extend("force", DEFAULT_OPTS, opts or {})

  -- Update appearance callback
  -- @param target_appearance: 'light' | 'dark'
  update_appearance = function(target_appearance)
    -- Apply user method if theme changes
    if target_appearance ~= state.appearance then
      state.appearance = target_appearance
      if type(user_opts.on_change) == "function" then
        user_opts.on_change(state.appearance)
      end
    end
  end

  -- Run on start if enabled
  if user_opts.run_on_start then
    -- should be run synchronously on startup
    -- to avoid the fast color change "glitch" effect
    Werewolf.run({ sync = true })
  end

  -- Start execution loop using vim.loop timer
  local timer = vim.loop.new_timer()
  local period = user_opts.period

  timer:start(period, period, vim.schedule_wrap(Werewolf.run))
end

--- Runs Werewolf manually, applying any configurations based
-- on the system theme
-- @param run_opts table: run options (sync/async)
-- @return nil
Werewolf.run = function(run_opts)
  run_opts = run_opts or { sync = false }
  local mode = user_opts.mode
  local day_time = user_opts.day_time
  local handler = nil

  if mode == "system" and Utils.os_uname == "Darwin" then
    handler = Utils.default_theme_handlers["system"][Utils.os_uname]
    handler(update_appearance, run_opts)
  else
    -- mode == "fixed_hours" is the fallback
    handler = Utils.default_theme_handlers["fixed_hours"]
    handler(day_time, update_appearance)
  end
end

return Werewolf
