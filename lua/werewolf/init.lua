---------------------
--- Werewolf.nvim ---
---------------------

local Utils = require("werewolf.utils")
local Werewolf = {}

-- Default configuration for Werewolf
local DEFAULT_OPTS = {
  get = Utils.get_theme,
  on_change = nil,
  run_on_start = true,
  period = 500,
  mode = "system",
  day_time = { from = 8, to = 20 },
}

-- User configuration currently loaded
local user_opts = DEFAULT_OPTS
local current_theme = nil

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

  -- Track the current theme
  local day_time = user_opts.day_time
  local mode = user_opts.mode
  current_theme = user_opts.get(mode, day_time)

  -- Run on start if enabled
  if user_opts.run_on_start then
    Werewolf.run({ force = true })
  end

  -- Start execution loop using vim.loop timer
  local timer = vim.loop.new_timer()
  local period = user_opts.period

  timer:start(period, period, vim.schedule_wrap(Werewolf.run))
end

--- Runs Werewolf manually, applying any configurations based
-- on the system theme
-- @param force boolean: If true, runs `on_change` even if theme did not change
-- @return nil
Werewolf.run = function(run_opts)
  run_opts = run_opts or { force = false }
  if type(user_opts.on_change) == "function" then
    local day_time = user_opts.day_time
    local mode = user_opts.mode
    local new_theme = user_opts.get(mode, day_time)

    -- Apply user method if theme changes or forced
    if run_opts.force or (new_theme ~= current_theme) then
      current_theme = new_theme
      user_opts.on_change(current_theme)
    end
  end
end

return Werewolf
