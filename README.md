# zed-mojo

A [Zed](https://zed.dev) editor extension for the [Mojo](https://www.modular.com/mojo) programming language.

## What It Does

- Syntax highlighting for `.mojo` and `.🔥` files
- Code completion, diagnostics, and hover documentation via `mojo-lsp-server`
- Auto-indentation and bracket matching
- Code outline in the symbols panel (`fn`, `def`, `struct`, `class`, `trait`)
- Vim text object support

## How to Use

### Prerequisites

Install the [Mojo SDK](https://docs.modular.com/mojo/) so that `mojo-lsp-server` is available.

The extension finds the LSP server automatically in this order:

1. **PATH** — works if `mojo-lsp-server` is globally available
2. **Pixi** — detects `pixi.toml` in the project and uses `.pixi/envs/default/bin/mojo-lsp-server`
3. **MODULAR_HOME** — uses `$MODULAR_HOME/pkg/packages.modular.com_mojo/bin/mojo-lsp-server`
4. **Default** — falls back to `~/.modular/pkg/packages.modular.com_mojo/bin/mojo-lsp-server`

If none of these work, set the path manually in Zed settings (`Cmd+,`):

```json
{
  "lsp": {
    "mojo-lsp-server": {
      "binary": {
        "path": "/path/to/mojo-lsp-server"
      }
    }
  }
}
```

### Using with Pixi

If your project uses [pixi](https://pixi.sh):

```sh
pixi add max
```

The extension will detect `pixi.toml` and use the pixi environment's `mojo-lsp-server` automatically.

## How to Build

### Requirements

- [Rust](https://rustup.rs/) toolchain

### Setup, Build, and Install

```sh
# One-time: install the wasm target
make setup

# Build the extension
make build

# Or build + see install instructions
make dev
```

Then in Zed: `Cmd+Shift+P` → **zed: install dev extension** → select this directory.

## Credits

- Tree-sitter grammar: [lsh/tree-sitter-mojo](https://github.com/lsh/tree-sitter-mojo)
- Reference: [modular/vscode-mojo](https://github.com/modular/vscode-mojo)
