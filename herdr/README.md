# herdr

Config for [herdr](https://herdr.dev) — a terminal workspace manager built
around AI coding agents. Migrated from `tmux/.tmux.conf.macos`.

| | |
|---|---|
| Live path | `~/.config/herdr/config.toml` → `herdr/config.toml` |
| Reload | `herdr server reload-config` (or `prefix+r`) |
| Validate | `herdr config check` — catches bad key syntax, unknown actions **and** duplicate bindings |
| Default reference | `herdr --default-config` |
| Version migrated against | 0.9.0 |

Only the single file is symlinked, not the directory — `~/.config/herdr/` also
holds the server socket, logs and `session.json`.

## Do not nest herdr and tmux

Both use `Ctrl+A` as prefix, and **the outer multiplexer wins every shared chord** —
prefix sequences, `alt+hjkl`, `alt+1..9`, `ctrl+y`, `ctrl+space`. herdr 0.9.0 has no
send-prefix/passthrough action, so a tmux running inside a herdr pane can never
receive `Ctrl+A` at all.

One nesting case is actively dangerous: inside tmux, `prefix+ctrl+r` is
**tmux-resurrect restore**, not herdr's resize mode.

Run one multiplexer per terminal window, and **start the herdr server from a window
with no tmux** — a server spawned inside a tmux pane inherits `TMUX` and
`TMUX_PANE`, which every `[ -n "$TMUX" ]` guard downstream will misread.

## Vocabulary

tmux **session** → herdr **workspace**. tmux **window** → herdr **tab**. Pane
stays a pane. A herdr *session* is a whole separate server namespace, which is
heavier than a tmux session — project-level things belong in workspaces.

## Keybinding map

`prefix` is `ctrl+a`, as in tmux. herdr takes an **array** per action, so a tmux
binding and its prefix-mode equivalent coexist rather than one displacing the other.

| tmux | herdr |
|---|---|
| `set -g prefix C-a` | `prefix = "ctrl+a"` |
| `bind h/j/k/l select-pane` | `focus_pane_left/down/up/right` (herdr default) |
| `bind р/о/л/д` (hjkl, RU layout) | kept as aliases — see below |
| `bind d detach-client` | `detach = ["prefix+q", "prefix+d"]` |
| `bind s choose-tree -Zs` | `workspace_picker = ["prefix+w", "prefix+s"]` |
| `bind , rename-window` | `rename_tab = ["prefix+shift+t", "prefix+comma"]` |
| `bind -n M-z resize-pane -Z` | `zoom = ["prefix+z", "alt+z"]` |
| `bind -n M-1..9 select-window` | `switch_tab = ["prefix+1..9", "alt+1..9"]` |
| `bind -n M-h` / `bind -n M-l`, and tmux-sensible's `prefix C-p` / `C-n` | `previous_tab = ["prefix+ctrl+p", "alt+h"]` / `next_tab = ["prefix+ctrl+n", "alt+l"]` |
| `bind -r C-k` / `bind -n M-k` swap-window | `move_tab_previous = ["prefix+ctrl+k", "alt+k"]` |
| `bind -r C-j` / `bind -n M-j` swap-window | `move_tab_next = ["prefix+ctrl+j", "alt+j"]` |
| `bind %` split side-by-side | `split_vertical = ["prefix+v", "prefix+%"]` |
| `bind '"'` split stacked | `split_horizontal = ["prefix+minus", "prefix+\""]` |
| `-c "#{pane_current_path}"` | `terminal.new_cwd = "follow"` |
| `bind r source-file` | `reload_config = ["prefix+shift+r", "prefix+r"]` |
| `bind p` tmux-palette | `goto = ["prefix+g", "prefix+p"]` |
| yankee on `C-y` | `copy_mode = ["prefix+[", "ctrl+y"]` |
| `bind -n C-Space last-window` | `last_pane = "ctrl+space"` — *approximation, see below* |
| `history-limit 50000` | `advanced.scrollback_limit_bytes` (bytes, not lines) |
| `setw -g mouse on` | `ui.mouse_capture` |
| gruvbox + `#fe8019` | `theme.name` + `ui.accent` |

**Splits are named after the divider**, vim-style: `split_vertical` puts panes
*side by side*. That is the opposite of tmux's `-h`/`-v` flag naming, so it is
easy to get backwards.

`prefix+r` is reload, matching tmux; herdr's default `resize_mode` moved to
`prefix+ctrl+r` to make room (free now that tmux-resurrect's `C-r` is gone).

`previous_tab` gives up herdr's default `prefix+p` because that key opens the
navigator — Karabiner maps Cmd+P to `Ctrl+A` then `p`, so Cmd+P keeps working.

### Karabiner is unaffected

The Cmd+HJKL / Cmd+Z / Cmd+P rules emit `Ctrl+A` followed by a key and match on
the *terminal* bundle ID. herdr runs in the same terminals with the same prefix,
so **`karabiner/karabiner.json` needs no changes** for the EN layout. Two limits:
the rules cannot tell which multiplexer should receive a chord (see nesting above),
and under the RU layout they depend on the Cyrillic aliases below.

### The Russian-layout bindings are KEPT, and the ASCII flag is not enough

`experimental.switch_ascii_input_source_in_prefix` forces an ASCII input source for
the duration of prefix mode, which fixes **hand-typed** `prefix+hjkl` under RU.

It does **not** fix the Karabiner path. Those rules post `Ctrl+A` and `h` as two
separate HID events, and macOS translates the second with whatever input source is
live at delivery — so under RU the PTY already holds `р` before herdr can switch
anything. The flag cannot win that race.

So the four Cyrillic aliases are kept alongside the flag. herdr's parser accepts
non-ASCII key tokens (`prefix+р` validates), so they cost nothing.

## What did not come across

| tmux | status |
|---|---|
| `C-Space last-window` | **no `last_tab` action exists.** `last_pane` is the closest — it tracks the last focused pane across tabs *and* workspaces, so it matches only when tabs hold one pane |
| `C-M-Space` last-session | **no equivalent.** Left unbound rather than mapped to something that behaves differently |
| `tmux_yankee` | no port. Native copy mode covers vim motions/search/yank but not line numbers, flash-style movement or text objects. `edit_scrollback` (`prefix+e`) opens scrollback in `$EDITOR` — i.e. LazyVim — which may cover more of it |
| `tmux-palette`, `tmux-fzf` | TPM plugins, not loadable. `goto` / `workspace_picker` are the built-in analogues |
| status-left / status-right | **no configurable status line.** Only `ui.tab_bar_right` with fixed entry types (`zoom`, `hostname`, `datetime`, `text`, `command`) |
| `@resurrect-processes` | layout and cwd are restored after a server restart; arbitrary programs come back as bare shells |
| `tmux-assistant-resurrect` | **not yet replaceable.** `session.resume_agents_on_restore` resumes agent conversations natively, but only with the agent integrations installed, and it does not import the plugin's saved state. It stays load-bearing while tmux is still primary |
| `prefix C-s` manual resurrect save | no equivalent checkpoint/rollback — herdr persistence is automatic |
| `monitor-activity` / `monitor-bell` | no per-tab activity or bell flag. The agent sidebar reports agent state, which is not the same signal |
| `bind M-n` renumber window, `bind v` join-pane, `bind b` break-pane, `bind M-v` move-window | no keyboard prompt; `herdr pane move` / `herdr tab` cover them from the CLI |
| `bind L` clear all panes | needs a `[[keys.command]]` + script; not yet written |

Persistence differs in shape. While the server runs, panes are never killed — but
**that is parity, not an advantage: an ordinary tmux detach already preserves
running processes.** Resurrect matters only after the server or the machine goes
away, and there tmux's process re-launching still wins.

### Muscle-memory traps

tmux keys that exist in herdr but mean something else. `prefix q` is the one that bites:

| key | tmux | herdr |
|---|---|---|
| `prefix q` | display-panes (harmless) | **detach** |
| `prefix b` | break-pane | toggle sidebar |
| `prefix v` | join-pane prompt | split |
| `prefix o` | next pane | open notification target |
| `prefix L` | clear all shell panes | swap pane right |

Also: tmux's `bind -r` repeat on `prefix C-k` / `C-j` is lost. herdr returns to
terminal mode after each action, so a second press without the prefix reaches the
shell — `ctrl+k` kills to end of line, `ctrl+j` sends a newline. Use `alt+k` /
`alt+j` to repeat.

## Status

**Migrated but not yet verified live.** Everything here passes `herdr config check`.
That is not the same as the keys arriving: validate from a terminal window running
**no tmux** — see the warning above.
