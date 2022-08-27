# 📝 prosemode.nvim




https://user-images.githubusercontent.com/14281621/187013305-6ff547dc-a585-422e-939a-b587e97bd069.mp4





A dead simple, pure lua, neovim plugin for writing prose. **prosemode.nvim** introduces a "prose mode" (toggled with `:ProseToggle`). The mode applies the minimal number of changes to keymappings and options with the biggest impact on the experience of writing prose in `nvim`. It minimizes potential conflicts with other plugins _without_ requiring plugin-level configuration options.

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

This will switch between having the mode on or off. _Note: some of the options it changes are vim window level, so strange behavior may occur when toggling the mode from different windows within the same `nvim` instance._ To deal with this, you can call `:ProseOn` or `:ProseOff` to apply the desired settings to the current window if it got left behind by a toggle.[^1]

[^1]: I plan to further reduce this friction in later updates using autocommands.

You can bind the commands to a key in your config if desired. For example:

```lua
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<leader>pt", ":ProseToggle<CR>", opts)
keymap("n", "<leader>pm", ":ProseOn<CR>", opts)
keymap("n", "<leader>po", ":ProseOff<CR>", opts)

-- additional keymaps here
```

In vimscript one can use:

```vim
nnoremap <silent> <leader>pt :ProseToggle<CR>
nnoremap <silent> <leader>pm :ProseOn<CR>
nnoremap <silent> <leader>po :ProseOff<CR>
```

Adjust these as desired for your setup or call the command(s) directly. (Note: I recommend using local variables as aliases in lua to take advantage of the language features and make your config more readable).

## Comparison to alternatives

- [vimpencil](https://github.com/preservim/vim-pencil) a vimscript plugin with many, many additional features including further changes to keymaps, new conceal settings, multiple wrap modes, changes to insert mode undo history, autoformating, and more. **prosemode.nvim** is not intended as a direct competitor but rather a simpler alternative with no need for additional configuration.

## credit

This plugin is my first time using lua and I relied heavily on the tutorial [here.](https://youtu.be/n4Lp4cV8YR0) It translates and improves the functionality of a vimscript snippet I found in a comment years ago to the new neovim lua API.
