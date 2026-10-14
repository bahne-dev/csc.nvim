# csc.nvim

Commit Scope Completer - intelligent scope suggestions for conventional commits in Neovim.

![Demo](./csc-demo.gif?v=3)

## Why csc.nvim?

**The Problem:** When writing [Conventional Commits](https://www.conventionalcommits.org/), you need consistency in your scope names. Did you use `auth` or `authentication`? Was it `ui` or `frontend`? Without consistency, your git history becomes fragmented and less useful.

**Existing Solutions Fall Short:** While there are scope completions available (like those in commitizen or @commitlint), they require Node.js dependencies and project-specific configuration files. You shouldn't need to install a JavaScript toolchain just to get smart completions for your commit messages!

**The csc.nvim Difference:**
- **Learns from YOUR repository**: no generic scope lists; analyzes your repository's commit history to suggest relevant scopes
- **Frequency-Based Ranking**: suggests scopes based on historical usage
- **Pure Lua**: no Node.js, no package.json, no .commitlintrc

Unlike JavaScript-based solutions that require polluting your project with config files and node_modules, csc.nvim lives entirely in your editor, learning from your actual commit history.

## Features

- **Context-Aware**: Only triggers within scope parentheses `type(|): description`
- **Intelligent Caching** - stays responsive even in large repos
- **nvim-cmp/blink.cmp Integration**: Works as nvim-cmp/blink.cmp source
- **Git Commit Guidelines**: Adds color columns at 50 and 72 characters for proper commit message formatting

## Requirements

- Neovim 0.8.0+
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) or [blink.cmp](https://github.com/saghen/blink.cmp)
- Git repository

## Installation

<details><summary>nvim-cmp</summary>

### Using lazy.nvim

```lua
{
  'hrsh7th/nvim-cmp',
  dependencies = {
    'bahne-dev/csc.nvim',
    -- other sources...
  },
  config = function()
    require('csc').setup()

    require('cmp').setup.filetype('gitcommit', {
      sources = {
        { name = 'csc' },
        { name = 'luasnip' }, -- optional but recommended (see "Works Great With" section)
      }
    })
  end
}
```

### Using packer.nvim

```lua
use {
  'hrsh7th/nvim-cmp',
  requires = {
    'bahne-dev/csc.nvim',
    -- other sources...
  },
  config = function()
    require('csc').setup()

    require('cmp').setup.filetype('gitcommit', {
      sources = {
        { name = 'csc' },
        { name = 'luasnip' }, -- optional but recommended (see "Works Great With" section)
      }
    })
  end
}
```

### Using vim-plug

```vim
Plug 'hrsh7th/nvim-cmp'
Plug 'bahne-dev/csc.nvim'
```

Then in your init.vim/init.lua after plug#end():

```vim
lua << EOF
  require('csc').setup()

  require('cmp').setup.filetype('gitcommit', {
    sources = {
      { name = 'csc' },
      { name = 'luasnip' }, -- optional but recommended (see "Works Great With" section)
    }
  })
EOF
```

### Minimal setup (optional)

If you prefer to only load csc.nvim as a source to nvim-cmp, without the other
functionality such as the helper commands and colorcolumns, you may replace:

```lua
require('csc').setup()
```

with

```lua
require('csc.cmp').register()
```

the completion suggestions will work exactly as before.

</details>

<details><summary>blink.cmp</summary>

### Using lazy.nvim

```lua
{
  'saghen/blink.cmp',
  dependencies = {
    { 'bahne-dev/csc.nvim', opts = {} },
    -- other sources...
  },
}
```

### Using packer.nvim

```lua
use {
  'saghen/blink.cmp',
  requires = {
    { 'bahne-dev/csc.nvim' },
    -- other sources...
  },
  config = function()
    require('csc').setup()
  end
}
```

### Using vim-plug

```vim
Plug 'saghen/blink.cmp'
Plug 'bahne-dev/csc.nvim'
```

Then in your init.vim/init.lua after plug#end():

```vim
lua << EOF
  require('csc').setup()
EOF
```

### Minimal setup (optional)

If you prefer to only load csc.nvim as a source to blink.cmp, without the other
functionality such as the helper commands and colorcolumns, you may drop the:

```lua
require('csc').setup()
-- or for lazy.nvim, the equivalent
opts = {}
```

the completion suggestions will work exactly as before.

</details>

## Usage

The plugin automatically activates when editing git commit messages.

Start typing a conventional commit and get scope suggestions:

```
feat(|): add new feature
     ^ completion menu appears:
       auth
       api
       ui
       database
```

Also works with a breaking change indicator:

```
refactor(|)!: change api 
         ^ completion menu appears:
           auth
           api
           ui
           database
```

Fuzzy matching (thanks to nvim-cmp/blink.cmp):

```
feat(db|): add new feature
       ^ completion menu appears:
         database
         debugger
```

## Works Great With

### LuaSnip + friendly-snippets

If you're using LuaSnip with friendly-snippets, you get the best of both worlds:
- **LuaSnip snippets** (from friendly-snippets) provide: `feat`, `fix`, `docs`, etc. to quickly start your commit
- **csc.nvim** provides: intelligent scope completion once you're inside the parentheses

## Configuration

```lua
require('csc').setup({
  debug = false,  -- enables printing debug messages
  max_suggestions = 5,  -- maximum number of scope suggestions returned (default: 10)
})
```

### Commands

- `:CSC analyze` - Analyze repository scope usage
- `:CSC status` - Show current buffer status
- `:CSC help` - Display available commands
- See [CONTRIBUTING.md](CONTRIBUTING.md) for more commands

## Troubleshooting

**No suggestions appearing?**
- Ensure the plugin is reading git history using `:CSC test_git`
- Check that your cursor is between the parentheses and in INSERT mode: `feat(|):`
- Verify the plugin loaded: `:CSC status`

**Wrong scopes or missing recent commits?**
- The plugin caches results for 30 seconds
- Only analyzes commits following conventional commit format
- Try `:CSC analyze` to see what scopes it found

**Still having issues?**
- Enable debug mode: `require('csc').setup({ debug = true })`
- Check `:messages` for debug output
- See [CONTRIBUTING.md](CONTRIBUTING.md) or `:CSC help` for more debugging commands

## License

[MIT](LICENSE)
