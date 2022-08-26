# prosemode.nvim

📝 A dead simple, pure lua, neovim plugin for writing prose. `prosemode.nvim` introduces a "prose mode" (toggled with `:ProseToggle`). The mode applies the minimal number of changes to keymappings and options with the biggest impact on the experience of writing prose in `nvim`. It minimizes potential conflicts with other plugins _without_ requiring plugin-level configuration options.

This plugin does not and will never touch any keymapping or options until toggled and will always leave your highlight groups, file type settings, conceal setting, formatting, etc. alone.

Requires neovim version > 0.7.

## Installation

- via [plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'liamtimms/prosemode.nvim`
```

- via [packer](https://github.com/wbthomason/packer.nvim)

```lua
use 'liamtimms/prosemode.nvim'
```

## Setup

- vimscript:

```vim
lua << EOF
require("prosemode").setup()
EOF
```

- lua:

```lua
require("prosemode").setup()
```

## Usage

The primary command to use is:

```vim
:ProseToggle
```

This will switch between having the mode on or off. It will save and restore options and keymaps when switching states. _Note: some of the options it changes are vim window level, so strange behavior_ may occur when toggling the mode in different windows (splits) within the same `nvim` instance._ I plan to address this soon.

You can bind the command to a key in your config if desired. For example:

```lua
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<leader>pm", ":ProseToggle<CR>", opts)

-- additional keymaps here
```

In vimscript one can use:

```vim
nnoremap <silent> <leader>pm :ProseToggle<CR>
```

You can adjust these as desired for your setup or call the command directly. (I recommend using local variables in lua to take advantage of the language and make your config more readable at the cost of some boilerplate verbosity).

## Comparison to alternatives

- [vimpencil](https://github.com/preservim/vim-pencil) a vimscript plugin with many, many additional features including further changes to keymaps, new conceal settings, multiple wrap modes, changes to insert mode undo history, autoformating, and more. `prosemode.nvim` is not indended as a direct competetor but a simpler alternative with no need of additional configuration.

## credit

This plugin is my first time using lua and I relying heavily on the tutorial [here.](https://youtu.be/n4Lp4cV8YR0) It translates and improves the functionality of a vimscript snippet I found in a comment years ago to the new neovim lua API.
