# telescope-luasnip

This plugin adds a [LuaSnip](https://github.com/L3MON4D3/LuaSnip) snippet picker to the already-awesome Neovim [Telescope plugin](https://github.com/nvim-telescope/telescope.nvim).

This is a port of [fhill2/telescope-ultisnips.nvim](https://github.com/fhill2/telescope-ultisnips.nvim) from Ultisnips to LuaSnip.  Thanks for the simple great idea!

**NOTE: This plugin is fairly new. If you find something wrong, please raise an issue or better yet, raise a PR.**

![telescope-luasnip.nvim in action](screenshot.png)

## Requirements

- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) (required)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (required)

## Setup

Install the plugin using your favourite package manager.

```lua
use {
    "benfowler/telescope-luasnip.nvim",
    module = "telescope._extensions.luasnip",  -- if you wish to lazy-load
}
```

Then, you need to tell Telescope about this extension somewhere after your
`require('telescope').setup()`, by calling:

```lua
require('telescope').load_extension('luasnip')
```

## Available functions

```lua
require'telescope'.extensions.luasnip.luasnip{}
vim.cmd [[ Telescope luasnip ]]
```

or

```vim
:Telescope luasnip
```

## Help!

Is there something not quite right or could be improved?  Log an issue with a
minimal reproduction, or better yet, raise a PR.

