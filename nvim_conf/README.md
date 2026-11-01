# Neovim

A quiet black editor with one status line, plain-text menus, and no permanent
buffer bar. Open a file normally, or use `nvim .` to browse a project.
The file tree closes after you select a file.

Use **Command** shortcuts, including while typing or selecting text:

| Keys | Action |
| --- | --- |
| `Cmd-P` | Find a file |
| `Cmd-/` | Search text across the project |
| `Cmd-E` | Toggle the file tree |
| `Cmd-Ctrl-T` | Show or hide the terminal, including from terminal input |
| `Cmd-Shift-P` | Command palette |
| `Cmd-S` | Save and keep typing |
| `Cmd-W` | Close the buffer; prompt for unsaved changes |

Ghostty forwards these shortcuts using its [CSI keybinding action](https://ghostty.org/docs/config/keybind/reference#csi).
The bindings are in the repository's `ghostty` config and the local macOS config.
Reload Ghostty with **Cmd-Shift-comma**, then restart Neovim.
These bindings apply throughout Ghostty: **Cmd-Shift-W** still closes the terminal
window. Use Ghostty's menu for its own command palette.

The following Space shortcuts remain available as a fallback. In normal mode,
press Space and pause to see them.

| Keys | Action |
| --- | --- |
| `Space Space` | Find a file, including dotfiles |
| `Space /` | Search text in the current project directory |
| `Space ,` | Switch between open buffers |
| `Space e` | Open or close the file tree |
| `Space fr` | Recent files in the current directory |
| `Space :` | Command palette |
| `Ctrl-s` / `Space w` | Save |
| `Space bd` | Close the buffer; prompt for unsaved changes |
| `[b` / `]b` | Previous / next buffer |
| `Space q` | Close the current window |
| `Space sv` / `Space sh` | Vertical / horizontal split |
| `Ctrl-h/j/k/l` | Move between windows, including the terminal |
| `Space tt` | Show or hide the same terminal session |
| `Esc Esc` in terminal | Return to normal mode; then `Space tt` hides it |
| `gd` / `gr` / `K` | Definition / references / documentation when LSP is attached |
| `Space cr` / `Space ca` / `Space cf` | Rename / code action / format via LSP |
| `Space cd` / `Space cl` | Current diagnostic / project diagnostics |
| `[d` / `]d` | Previous / next diagnostic |
| `Space ur` / `Space uw` | Toggle relative numbers / line wrapping |

In search menus, type to filter, use the arrow keys or `Ctrl-n`/`Ctrl-p` to move,
press Enter to open, and Esc to dismiss. Completion only accepts an item after
you select it with Tab, the arrow keys, or `Ctrl-n`; Enter otherwise inserts a
newline. The interface works with an ordinary terminal font.

Requires Neovim 0.11.3+ (tested on 0.11.6), Git, and a C compiler for syntax
parsers. Install `ripgrep` for project text search. From the repository root,
link `nvim_conf` to `~/.config/nvim` if you have not already configured Neovim.
Plugins install on first launch; `:Lazy restore` restores the checked-in versions.

Mason installs `clangd` and `rust-analyzer`. Python and Verilog language servers
are optional: use `:MasonInstall pyright` (requires Node/npm) or
`:MasonInstall svls` (requires Rust/Cargo), then restart Neovim.
HDL extensions, including Bluespec, retain Verilog syntax highlighting.

The syntax plugin stays on its [Neovim 0.11-compatible branch](https://github.com/nvim-treesitter/nvim-treesitter/tree/master).
Telescope is pinned to v0.1.9 to avoid the old file finder's deprecation warnings.
