# My Neovim Configuration

![rust-btw](https://user-images.githubusercontent.com/7014/219984419-84b6829f-2926-4576-96b6-cbe20708b007.png) *Rust configuration at `lua/plugins/extras/rust.lua`*

## 🚀 Getting Started

### 1. Make a backup of your current Neovim files:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

### 2. Clone the starter

```sh
git clone https://github.com/igorgue/dotnvim ~/.config/nvim
```

### 3. Start Neovim!

```sh
nvim
```

Refer to the comments in the files on how to customize **LazyVim**.

## 📂 File Structure

<pre>
~/.config/nvim
lua
├── config
│   ├── autocmds.lua
│   ├── keymaps.lua
│   ├── lazy.lua
│   └── options.lua
├── plugins
│   ├── coding.lua
│   ├── colorscheme.lua
│   ├── debugging.lua
│   ├── disabled.lua
│   ├── editor.lua
│   ├── extras
│   │   └── lang
│   │       ├── dart.lua
│   │       ├── elixir.lua
│   │       ├── html_css.lua
│   │       ├── lua.lua
│   │       ├── python.lua
│   │       ├── rust.lua
│   │       └── sql.lua
│   ├── lsp.lua
│   └── ui.lua
└── utils
    ├── init.lua
    └── ui.lua
</pre>
