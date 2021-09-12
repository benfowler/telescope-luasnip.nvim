# telescope-luasnip

Crude and barely functional integration for
[LuaSnip](https://github.com/L3MON4D3/LuaSnip) with
[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).

This is a port of
[fhill2/telescope-ultisnips.nvim](https://github.com/fhill2/telescope-ultisnips.nvim)
from Ultisnips to LuaSnip.  Thanks for the simple great idea!

(insert screenshot here)

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

