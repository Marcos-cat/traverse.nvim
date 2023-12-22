<!-- Link to this GitHub page: [The GitHub](https://github.com/Marcos-cat/traverse.nvim) -->

# ↕️ traverse.nvim

Traverse your wiki with one command

- *Problem*: Markdown links are complicated (`gf` doesn't always work).
- *Solution*: Encapsulate all the behavior in a single command - `Traverse`

## ✨ Features

- [x] Open web links and file links with the same command
- [x] Navigate while on any part of the Markdown link
- [x] [Toggle Markdown checkboxes](#toggle-checkboxes)
- [x] Navigate Markdown Section links
- [x] Navigate Markdown Reference links

## 📦 Install

- With [lazy.nvim][lazy]:
  ```lua
  {
      'Marcos-cat/traverse.nvim', 
      opts = {},
      cmd = 'Traverse' -- Optional: Lazy loads the plugin only when the command is used
  },
  ```

## 💻 Usage

- This plugin requires a call to `setup()` (if you use [lazy.nvim][lazy] then
  this is handled for you). E.g.:

  ```lua
  require('traverse').setup{}
  ```

- `:Traverse` Call this command to *traverse* markdown

## API Commands

```lua
local utils = require 'traverse.utils'
```

### Toggle Checkboxes

`utils.checkbox.toggle()` will toggle a markdown checkbox on the current line if
there is one.

## Options

- TODO: Add options

## 📚 Description

This plugin has the goal to solve a problem: Markdown links are more than just
file paths. A Markdown link in a wiki, for example, often looks like this:
`[My File](path/to/file.md)`. If the user's cursor is anywhere except in between
the parentheses then `gf` will not work. Or if the link points to a website
rather than a local file, then `gf` won't work, and if not setup correctly,
neither will `gx`. This plugin enhances these functionalities by defining a new
command `Traverse` that handles all of these cases elegantly and makes use of
the `confirm()` function (see `:help confirm()`) to handle cases where your
intent is not obvious.

[lazy]: https://github.com/folke/lazy.nvim
