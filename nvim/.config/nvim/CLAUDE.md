# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a customized Neovim configuration based on kickstart.nvim, optimized for data science and research workflows. The configuration is modular and organized under the `lua/luba/` namespace.

## Configuration Architecture

### Core Structure
- `init.lua` - Entry point that loads all configuration modules
- `lua/luba/config/` - Basic Neovim settings (options, keymaps, autocmds)
- `lua/luba/core/` - Core functionality (lazy.nvim setup, native LSP)
- `lua/luba/plugins/` - Plugin configurations using lazy.nvim
- `lua/luba/plugins-deprected/` - Deprecated plugin configurations (kept for reference)
- `lsp/` - LSP server-specific configurations
- `current-theme.lua` - Theme selection (currently kanagawa)

### Plugin Management
Uses lazy.nvim as the plugin manager. All plugins are configured in `lua/luba/plugins/` with automatic loading via `require('lazy').setup({ import = 'luba.plugins' })`.

### LSP Configuration
Uses Neovim's native LSP client (vim.lsp.enable) with these language servers:
- `ruff` - Python linting and formatting
- `ty` - Python type checking
- `lua_ls` - Lua language server  
- `jedi_language_server` - Python language server

## Data Science Features

### Jupyter Integration
- **Molten.nvim**: Jupyter kernel integration for executing code cells
- **Quarto**: Literate programming support for .qmd files
- **Otter.nvim**: LSP support within code cells
- **Jupytext**: Convert between notebook and text formats
- **Image.nvim**: Display images inline

### Key Bindings for Data Science
- `<M-i>`: Insert Python code chunk in quarto files
- `<leader>cf`: Open IPython terminal
- `<localleader>mi`: Initialize Molten (Jupyter)
- `<localleader>md`: Stop Molten
- `<localleader>mp`: Show Molten image popup

## Key Mappings

### Leader Keys
- Leader: `<Space>`
- Local leader: `<Space>`

### Navigation & File Management
- `-`: Open Oil file manager in float mode
- `<leader>sf`: Search files with Telescope
- `<leader>sg`: Live grep with Telescope
- `<leader>sn`: Search Neovim config files

### Code Operations
- `<leader>cf`: Format code with Conform.nvim
- `<leader>e`: Show diagnostic errors
- `<leader>y`: Copy to system clipboard
- `<C-a>`: CodeCompanion actions
- `<LocalLeader>a`: Toggle CodeCompanion chat

### Development Tools
- `<C-u>/<C-d>`: Center screen when scrolling
- `K` (visual): Move selection up
- `J` (visual): Move selection down

## Formatters and Linters

### Python
- **Ruff**: Used for linting, formatting, import organization, and fixing
- Configured in `lsp/ruff.lua` with comprehensive rule selection

### Lua
- **Stylua**: Code formatting with 2-space indentation

### Other Languages
- **Prettier/Prettierd**: JSON formatting
- **Injected formatters**: For code blocks in markdown/quarto files

## Common Workflows

### Plugin Management
- `:Lazy` - Open plugin manager
- `:Lazy update` - Update all plugins
- `:Lazy sync` - Sync plugin state with configuration

### LSP Operations
- Use native Neovim LSP commands (`:h lsp`)
- Diagnostics configured with custom icons and floating windows

### Working with Notebooks
1. Open .qmd or .ipynb file
2. Use `<localleader>mi` to initialize Molten
3. Execute code cells with Molten commands
4. Use `<M-i>` to insert new Python code chunks

## Dependencies

### External Tools Required
- `git`, `make`, `unzip`, C compiler
- `ripgrep` - Fast text search
- `stylua` - Lua formatting
- `ruff` - Python tooling
- Nerd Font for icons
- `xclip` - Clipboard integration (Linux)

### Optional Python Dependencies
- `jupyter` - For notebook functionality
- `ipython` - Enhanced Python REPL
- Various packages for data science workflows

## File Types

### Specialized Support
- **Quarto (.qmd)**: Literate programming with code execution
- **Python (.py)**: Full LSP support with Ruff and Jedi
- **Lua (.lua)**: Native LSP with lua_ls
- **Jupyter (.ipynb)**: Via Jupytext and Molten integration
- **Markdown (.md)**: Enhanced editing with vim-pencil integration

## Troubleshooting

### Plugin Issues
- Check `:Lazy` for plugin status
- Use `:checkhealth` for general diagnostics
- LSP issues: `:LspInfo` and `:LspLog`

### Molten/Jupyter Issues
- Ensure Python kernel is available
- Check that `image.nvim` dependencies are installed
- Verify Molten initialization with `:MoltenInfo`

## Theme and Appearance
- Current colorscheme: Kanagawa
- Nerd Font icons enabled
- Custom diagnostic signs with Unicode symbols
- Transparent backgrounds and rounded borders where applicable