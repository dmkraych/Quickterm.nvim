# "Quickterm.nvim"

Quickly create a terminal that saves state when hidden.

<!-- TOC -->

[Requirements](#requirements)
[Installation](#installation)
[Options](#options)
[Roadmap](#roadmap)

<!-- TOC -->

## Requirements

Tested on neovim 0.11.0-2, though the implementation is basic enough that it should work on most versions. No additional dependencies.

## Installation

Currently only tested with [lazy.nvim](https://github.com/folke/lazy.nvim), with additional plugin manager support planned.

```lua
{
    'dmkraych/Quickterm.nvim',
    opts = {},
    config{},
}
```

## Options

The following listed options are the <i>defaults</i>; you can adjust any of them to your choosing, or leave the `opts{}` table empty to retain the defaults.

```lua
{
    opts = {
        theme = "floating", -- other themes are 'top' and 'bottom'
        mapping = "<leader>st", -- won't overload keymaps, including the default

        win_config{ --- overrides theme values
            relative = "editor",
            width = math.floor(vim.o.columns * 0.6),
            height = math.floor(vim.o.lines * 0.6),
            col = math.floor((vim.o.columns * 0.4) / 2),
            row = math.floor((vim.o.lines * 0.4) / 2),
            border = "double",
        },
    }
}
```

## Roadmap

Please keep in mind this plugin is in its very earliest stages; I anticipate several breaking changes. That being said, my current priorities are:

1. Ensure support for other major plugin managers
2. Manage overloading of keymaps
3. Better dynamic resizing
4. Add mouse support for resizing and moving floating windows.

Beyond that, if I get any requests that are within my capacity, I'll endeavor to add them!

## Acknowledgements

If it's not clear, this is largely based on the floaterminal by Neovim legend [tjdevries](https://github.com/tjdevries), from his Advent of Neovim 2024 series.
