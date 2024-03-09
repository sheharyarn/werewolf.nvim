# Werewolf.nvim

![Neovim](https://img.shields.io/badge/Neovim-%2357A143?NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![LICENSE](https://shields.io/badge/LICENSE-MIT-orange?style=for-the-badge)


> Apply custom Neovim configs based on system theme

`werewolf.nvim` is a handy neovim plugin that automatically changes the theme, apply configs or run custom code depending on the system theme or the time of day. This plugin actively listens for changes, so it can apply configs at runtime when the system theme changes from light to dark or vice versa, without needing to restart Neovim.

<br>



## Installation

**Packer:**

```lua
use 'sheharyarn/werewolf.nvim'
```

**Lazy:**

```lua
{ 'sheharyarn/werewolf.nvim', lazy = false }
```

<br>



## Configuration


## Default Options

By default, `werewolf` does not apply any custom code/theme on
system theme change or other events.

Any options passed to `setup()` will be merged with these
default options before being applied.

```lua
{
  system_theme = {
    get = require('werewolf.utils').get_theme,
    on_change = nil,
    run_on_start = true,
    period = 500,
  },
}
```


## Apply Neovim theme on system theme change

In your `init.lua`, add the following:

```lua
-- Example assumes material.nvim plugin is installed

require('werewolf').setup({
  system_theme = {
    on_change = function(theme)
      if theme == 'Dark' then
        vim.g.material_style = 'deep ocean'
        vim.o.background = 'dark'
        vim.cmd('colorscheme material')
      else
        vim.g.material_style = 'lighter'
        vim.o.background = 'light'
        vim.cmd('colorscheme material')
      end
    end,

    period = 200,  -- Optionally change the theme check interval from default of `500` ms
  },
})
```

If you have a more complex theme/styling configuration or want to
run additional code on system theme change events, it's better to
move that code out into separate functions and call them inside
`on_change`:

```lua
if theme == 'Dark' then
  MyUtils.dark_theme()
else
  MyUtils.light_theme()
end
```

See [another example here][dotfiles-example].



<br>



## Contributing

- [Fork][github-fork], Enhance, Send PR
- Lock issues with any bugs or feature requests
- Implement something from Roadmap
- Spread the word ❤️

<br>



## License

This package is available as open source under the terms of the [MIT License][license].

<br>



  [github-fork]:      https://github.com/sheharyarn/werewolf.nvim/fork
  [license]:          https://opensource.org/licenses/MIT

  [dotfiles-example]: https://github.com/sheharyarn/dotfiles/blob/7a5f6ac7adde7c1d97bfb1af8d79b51904f1b364/Vim/init.lua#L54-L68
