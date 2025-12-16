# LazyVim Configuration

Custom LazyVim setup with vim-surround style keybindings, buffer-centric navigation, and Russian keyboard support.

## Installation

1. Backup existing Neovim config:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Symlink this config:
   ```bash
   ln -s ~/.dotfiles/lazyvim ~/.config/nvim
   ```

3. Start Neovim - plugins will install automatically.

4. Enable Python support (optional):
   ```
   :LazyExtras
   ```
   Search `python`, enable `lang.python`.

## Key Customizations

### Buffer Navigation (J/K instead of default)

Normal vim `J` (join lines) and `K` (hover) are remapped to enable fast buffer switching:

| Key | Action |
|-----|--------|
| `J` | Next buffer |
| `K` | Previous buffer |
| `m` | Move buffer right |
| `M` | Move buffer left |
| `g1`-`g9` | Go to buffer 1-9 |

**Remapped original functions:**
| Key | Action |
|-----|--------|
| `gj` | Join lines (original `J`) |
| `gh` | LSP hover (original `K`) |

### Marks

Since `m` is used for buffer move:

| Key | Action |
|-----|--------|
| `<leader>mm` | Set mark (then press letter) |
| `` `a `` | Go to mark `a` (exact position) |
| `'a` | Go to mark `a` (line) |
| `<leader>sm` | Search marks (picker) |

### Line Navigation

| Key | Action |
|-----|--------|
| `H` | Go to first non-blank character |
| `L` | Go to end of line |

Works in normal and visual mode. Also mapped for Russian keyboard layout (Р/Д).

### Visual Mode

| Key | Action |
|-----|--------|
| `J` / `<C-j>` | Move selection down |
| `K` / `<C-k>` | Move selection up |
| `p` | Paste without yanking replaced text |
| `P` | Paste and yank replaced text |
| `gc` | Toggle comment |
| `S{char}` | Surround selection |

### Surround (vim-surround style)

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surrounding |
| `yss{char}` | Surround entire line |
| `ds{char}` | Delete surrounding |
| `cs{old}{new}` | Change surrounding |
| `S{char}` | Surround selection (visual mode) |

Examples:
- `ysiw"` - surround word with quotes
- `yss)` - surround line with parentheses
- `ds"` - delete surrounding quotes
- `cs"'` - change double quotes to single

### Window Management

| Key | Action |
|-----|--------|
| `<Up>` | Increase window height |
| `<Down>` | Decrease window height |
| `<Left>` | Increase window width |
| `<Right>` | Decrease window width |

Supports count: `5<Up>` increases height by 5 lines.

### Scrolling

| Key | Action |
|-----|--------|
| `<C-n>` | Scroll screen down (cursor stays) |
| `<C-p>` | Scroll screen up (cursor stays) |

### Search

| Key | Action |
|-----|--------|
| `/` | Search with flash labels |
| `*` | Search word under cursor (flash) |
| `#` | Search word under cursor backward (flash) |
| `\` | Clear search highlights |
| `s` | Flash jump |

### Blank Lines

| Key | Action |
|-----|--------|
| `<leader>o` | Insert blank line below |
| `<leader>O` | Insert blank line above |

Supports count: `3<leader>o` inserts 3 blank lines.

### Command Line (Emacs-style)

| Key | Action |
|-----|--------|
| `<C-a>` | Go to start |
| `<C-e>` | Go to end |
| `<C-b>` | Move left |
| `<C-f>` | Move right |
| `<C-d>` | Delete character |
| `<M-b>` | Move word left |
| `<M-f>` | Move word right |

## LazyVim Default Keys (Reference)

### File/Buffer Operations

| Key | Action |
|-----|--------|
| `<leader><space>` | Find files |
| `<leader>/` | Live grep |
| `<leader>:` | Command history |
| `<leader>fb` | Browse buffers |
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>bd` | Delete buffer |

### Search (Picker)

| Key | Action |
|-----|--------|
| `<leader>sw` | Grep word/selection |
| `<leader>sg` | Live grep |
| `<leader>sm` | Search marks |
| `<leader>s/` | Search history |
| `<leader>sj` | Jumplist |

**In picker window:**
| Key | Action |
|-----|--------|
| `<C-n>` | Scroll preview down |
| `<C-p>` | Scroll preview up |
| `<C-j>` | Next item |
| `<C-k>` | Previous item |

### LSP

| Key | Action |
|-----|--------|
| `gh` | Hover documentation |
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Go to implementation |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>cf` | Format |

### Diagnostics (Trouble)

| Key | Action |
|-----|--------|
| `<leader>xx` | Diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xQ` | Quickfix list |
| `<leader>xL` | Location list |
| `<leader>cs` | Symbols |
| `<leader>cS` | LSP references/definitions |

### UI Toggles

| Key | Action |
|-----|--------|
| `<leader>uw` | Toggle line wrap |
| `<leader>ul` | Toggle line numbers |
| `<leader>ur` | Toggle relative numbers |
| `<leader>uc` | Toggle conceal |
| `<leader>uh` | Toggle inlay hints |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gf` | Git files |
| `<leader>gc` | Git commits |
| `<leader>gb` | Git blame line |
| `]h` | Next hunk |
| `[h` | Previous hunk |

### Terminal

| Key | Action |
|-----|--------|
| `<C-/>` | Toggle terminal |

## Plugins

### Included (Custom)

- **vscode.nvim** - VSCode dark theme with transparency
- **mini.surround** - Surround operations (vim-surround keybindings)
- **flash.nvim** - Enhanced navigation with labels
- **mini-hipatterns** - Color preview for hex codes

### From LazyVim

- snacks.nvim (picker, explorer, terminal)
- bufferline.nvim (buffer tabs)
- lualine.nvim (statusline)
- which-key.nvim (keybinding hints)
- trouble.nvim (diagnostics)
- And many more...

## Options

| Option | Value | Description |
|--------|-------|-------------|
| `scrolloff` | 0 | Allow `zt` to put cursor at top |
| `timeoutlen` | 50 | Fast key sequence timeout |
| `relativenumber` | auto | Relative in normal, absolute in insert |
| `globalstatus` | false | Separate statusline per window |

## File Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua     # Auto commands
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── lazy.lua         # Plugin manager setup
│   │   └── options.lua      # Vim options
│   └── plugins/
│       ├── colorscheme.lua  # VSCode theme
│       ├── editor.lua       # mini.surround, which-key
│       ├── flash.lua        # Flash.nvim config
│       ├── lsp.lua          # Treesitter, LSP settings
│       ├── snacks.lua       # Picker/explorer config
│       └── ui.lua           # Lualine, bufferline
└── .gitignore
```

## Russian Keyboard Support

The config includes `langmap` for Russian keyboard layout. Most navigation keys work in both layouts:

- `Р` (Russian H) → `^` (line start)
- `Д` (Russian L) → `$` (line end)

## Tips

1. **Which-key**: Press `<leader>` and wait to see available keybindings
2. **Lazy**: Press `<leader>l` to open plugin manager
3. **Mason**: Press `<leader>cm` to manage LSP servers, formatters, linters
4. **LazyExtras**: Run `:LazyExtras` to enable additional features
