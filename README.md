# 🤖 AI-Powered Neovim Configuration

**A modern, AI-first development environment built on LazyVim**

![rust-btw](https://user-images.githubusercontent.com/7014/219984419-84b6829f-2926-4576-96b6-cbe20708b007.png) 
*Multi-language support with advanced AI integration*

## ✨ Key Features

### 🤖 **AI-First Development**
- **CodeCompanion.nvim** - Advanced AI coding assistant with chat interfaces
- **Multiple AI Providers** - OpenAI, Anthropic, Google Gemini, and more
- **MCP Hub Integration** - Model Context Protocol for extended AI capabilities
- **VectorCode** - Enhanced code search and semantic analysis
- **Image Support** - Paste images directly into AI chat contexts
- **Intelligent Workflows** - Chain multiple AI prompts automatically

### 🌍 **Comprehensive Language Support**
- **Systems Programming**: Rust, C, Zig, Hare, Odin
- **Web Development**: HTML/CSS, JavaScript, Tailwind CSS
- **Backend**: Python, Elixir, Ruby, Java, SQL
- **Mobile**: Swift, Dart (Flutter)
- **Functional**: Clojure, Standard ML
- **Creative Coding**: SonicPi (music programming)
- **Emerging**: Nim, Mojo, V, QBE IR, ISPC
- **DevOps**: Docker, CMake, Nix, Shell scripting

### 🎨 **Minimalist Design Philosophy**
- **Clean Interface** - No line numbers, auto-hiding elements
- **Focus Mode** - Distraction-free coding environment
- **Multiple Themes** - Extensive colorscheme support with custom fixes
- **Responsive UI** - Adapts to your workflow needs

### 🔧 **Advanced Development Tools**
- **Debugging** - Full DAP integration with multiple language support
- **Git Integration** - Advanced git workflows and browsing
- **LSP Configuration** - Comprehensive language server setup
- **Testing** - Built-in test running and debugging
- **Code Quality** - Formatting, linting, and static analysis
- **Documentation** - Docsets integration and help systems

## 🚀 Quick Start

### Prerequisites
- Neovim 0.11+ 
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (recommended)
- Node.js (for some language servers)

### Installation

1. **Backup your current config:**
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

4. **Let plugins install automatically** - LazyVim will bootstrap and install everything on first run.

## 📁 Project Structure

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

## 🛠️ Customization

This configuration is built on **LazyVim**, making it highly modular and customizable:

- **Add Languages**: Create files in `lua/plugins/extras/lang/`
- **Configure AI**: Modify `lua/plugins/extras/ai/` files
- **Customize Keymaps**: Edit `lua/config/keymaps.lua`
- **Add Plugins**: Create new files in `lua/plugins/`
- **Theme Changes**: Modify `lua/plugins/colorscheme.lua`

### LazyVim Extras
This config includes many LazyVim extras for enhanced functionality:
- DAP (Debug Adapter Protocol)
- Language support for 20+ languages
- Advanced editor features (Navic, Dial, Snacks Explorer)
- Code formatting and linting

## 🤝 AI Integration Details

### CodeCompanion Features
- **Chat Interface** - Interactive AI conversations in Neovim buffers
- **Inline Assistance** - Direct code suggestions and modifications
- **Variable Management** - Context-aware code understanding
- **Custom Workflows** - Automated AI-powered code transformations
- **Multi-Provider Support** - Switch between different AI models

### Supported AI Providers
- OpenAI (GPT-3.5, GPT-4)
- Anthropic (Claude)
- Google (Gemini)
- OpenRouter (various models)
- Local models via Ollama

## 🎯 Philosophy

This configuration embraces:
- **AI-Enhanced Development** - Leverage AI without losing control
- **Minimalist Aesthetics** - Clean, focused interface
- **Multi-Language Flexibility** - One config for all your projects
- **Modern Tooling** - Latest Neovim features and plugins
- **Developer Productivity** - Reduce friction, increase flow

## 📚 Learning Resources

- [LazyVim Documentation](https://lazyvim.github.io/)
- [CodeCompanion.nvim Docs](https://github.com/olimorris/codecompanion.nvim)
- [Neovim Documentation](https://neovim.io/doc/)

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Open issues for bugs or suggestions
- Fork and adapt to your needs
- Share improvements via pull requests

## 📄 License

See [LICENSE](LICENSE) file for details.

---

**Built with ❤️ by [@igorgue](https://github.com/igorgue)**
