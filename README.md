# traverse.nvim

Traverse your wiki with one command

## Introduction

This plugin has the goal to solve a problem: Markdown links are more than just file paths. A Markdown link in a wiki, for example, often looks like this: `[My File](path/to/file.md)`. If the user's cursor is anywhere except in between the parentheses then `gf` will not work. Or if the link points to a website rather than a local file, then `gf` won't work, and if not setup correctly, neither will `gx`. This plugin enhances these functionalities by defining a new command `Traverse` that handles all of these cases elegantly and makes use of the `confirm()` function (see `:help confirm()`) to handle cases where your intent is not obvious.

## Install

- With [lazy.nvim](https://github.com/folke/lazy.nvim):
    ```lua
    {
        'Marcos-cat/traverse.nvim', 
        opts = {},
        cmd = 'Traverse' -- Optional: Lazy loads the plugin only when the command is used
    },
    ```

## Usage

- This plugin requires a call to `setup()` (if you use [lazy.nvim](https://github.com/folke/lazy.nvim) then this is handled for you). E.g.:
    ```lua
    require('traverse').setup {}
    ```

- `:Traverse`
    Call this command to *traverse* Markdown

## Options

- TODO: Add options
