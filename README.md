# Modern Neovim Configuration

**A modular, multi-language development environment powered by LazyVim**

![rust-btw](https://user-images.githubusercontent.com/7014/219984419-84b6829f-2926-4576-96b6-cbe20708b007.png)
_Multi-language support, minimalist design, and advanced developer tools._

## Key Features

  - **Zero Configuration** – Works out of the box with automatic plugin installation.
  - **Minimalist Design** – Clean, distraction-free interface with auto-hiding elements.
  - **Multi-Language Support** – Supports over 20 languages, including Rust, Python, JavaScript, Swift, and more.
  - **Optional AI Integration** – CodeCompanion supports multiple providers (OpenAI, Anthropic, Gemini).
  - **Advanced Development Tools** – Integrated debugging, testing, Git, and LSP support.
  - **LazyVim-Based** – Modular architecture for easy customization and extension.
  - **Extensive Theming** – Multiple color schemes with custom fixes and a responsive UI.
  - **Performance Optimized** – Fast startup with lazy loading and efficient plugin management.

### **Minimalist Design Philosophy**

- **Clean Interface** – No line numbers, auto-hiding elements
- **Focus Mode** – Distraction-free coding environment
- **Multiple Themes** – Extensive colorscheme support with custom fixes
- **Responsive UI** – Adapts to your workflow needs

### **Advanced Development Tools**

- **Debugging** – Full DAP integration with multi-language support
- **Git Integration** – Advanced Git workflows and browsing
- **LSP Configuration** – Comprehensive language server setup
- **Testing** – Built-in test running and debugging
- **Code Quality** – Formatting, linting, and static analysis
- **Documentation** – Docsets integration and help systems

### **Optional AI Features**

- **CodeCompanion** – Chat, inline code suggestions, and automated workflows
- **Multiple Providers** – OpenAI, Anthropic, Google Gemini, and more (optional)
- **Semantic Code Search** – Enhanced navigation and analysis

### **Comprehensive Language Support**

- **Systems Programming**: Rust, C, Zig, Hare, Odin
- **Web Development**: HTML/CSS, JavaScript, Tailwind CSS
- **Backend**: Python, Elixir, Ruby, Java, SQL
- **Mobile**: Swift, Dart (Flutter)
- **Functional**: Clojure, Standard ML
- **Creative Coding**: SonicPi (music programming)
- **Emerging**: Nim, Mojo, V, QBE IR, ISPC
- **DevOps**: Docker, CMake, Nix, Shell scripting

### **Minimalist Design Philosophy**

- **Clean Interface** – No line numbers, auto-hiding elements
- **Focus Mode** – Distraction-free coding environment
- **Multiple Themes** – Extensive colorscheme support with custom fixes
- **Responsive UI** – Adapts to your workflow needs

### **Advanced Development Tools**

- **Debugging** – Full DAP integration with multi-language support
- **Git Integration** – Advanced Git workflows and browsing
- **LSP Configuration** – Comprehensive language server setup
- **Testing** – Built-in test running and debugging
- **Code Quality** – Formatting, linting, and static analysis
- **Documentation** – Docsets integration and help systems

## Quick Start

### Prerequisites

- Neovim 0.11+
- Git
- [Nerd Font](https://www.nerdfonts.com/) (recommended)
- Node.js (required for some language servers)

### Installation

1. **Backup your current configuration:**

   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   ```

2. **Clone this configuration:**

   ```bash
   git clone https://github.com/igorgue/dotnvim ~/.config/nvim
   ```

3. **Start Neovim:**

   ```bash
   nvim
   ```

4. **Allow plugins to install automatically.** LazyVim will bootstrap and install everything on the first run.

## Project Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/                 # Core Neovim configuration
│   │   ├── autocmds.lua       # Auto commands
│   │   ├── keymaps.lua        # Key mappings
│   │   ├── lazy.lua           # Plugin manager setup
│   │   ├── options.lua        # Neovim options
│   │   └── cmds.lua           # Custom commands
│   ├── plugins/                # Plugin configurations
│   │   ├── ai/                # AI-related plugins
│   │   │   ├── codecompanion.lua
│   │   │   ├── copilot.lua
│   │   │   └── ...
│   │   ├── extras/            # Optional features
│   │   │   ├── lang/          # Language-specific configs
│   │   │   ├── ai/            # Additional AI tools
│   │   │   └── ...
│   │   ├── coding.lua         # Code editing enhancements
│   │   ├── colorscheme.lua    # Theme configuration
│   │   ├── editor.lua         # Editor functionality
│   │   ├── git.lua           # Git integration
│   │   ├── lsp.lua           # Language server setup
│   │   ├── treesitter.lua    # Syntax highlighting
│   │   └── ui.lua            # User interface
│   └── utils/                 # Utility functions
├── snippets/                  # Custom code snippets
├── ftplugin/                  # Filetype-specific settings
└── assets/                    # Documentation assets
```

## Customization

This configuration is built on **LazyVim**, making it highly modular and customizable:

- **Add Languages**: Create files in `lua/plugins/extras/lang/`
- **Customize Keymaps**: Edit `lua/config/keymaps.lua`
- **Add Plugins**: Create new files in `lua/plugins/`
- **Theme Changes**: Modify `lua/plugins/colorscheme.lua`
- **Enable or disable AI features**: AI tools are optional and can be configured in `lua/plugins/extras/ai/`

### LazyVim Extras

This configuration includes many LazyVim extras for enhanced functionality:

- DAP (Debug Adapter Protocol)
- Language support for over 20 languages
- Advanced editor features (Navic, Dial, Snacks Explorer)
- Code formatting and linting

## Learning Resources

- [LazyVim Documentation](https://lazyvim.github.io/)
- [CodeCompanion.nvim Docs](https://github.com/olimorris/codecompanion.nvim)
- [Neovim Documentation](https://neovim.io/doc/)

## Contributing

This is a personal configuration, but feel free to:

- Open issues for bugs or suggestions
- Fork and adapt it to your needs
- Share improvements via pull requests

## License

See the [LICENSE](LICENSE) file for details.

---

**Built by [@igorgue](https://github.com/igorgue)**
