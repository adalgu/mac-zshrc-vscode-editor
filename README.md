# Mac .zshrc VS Code Editor

This project provides a simple and efficient way to edit your `.zshrc` file using Visual Studio Code on macOS.

### What's New (Modular .zshrc support)

The included `setup.sh` now installs an enhanced `zshrc()` helper that:

- Lets you interactively select which files to edit:
  - `~/.zshrc`
  - Any modular files under `~/.zshrc.d/*.zsh`
  - Optionally `~/.zsh_secrets` (not tracked)
- Detects your editor (`code`, `subl`, `mate`, `bbedit`, `$EDITOR`, or falls back to `nano`) and waits for edits
- Reloads `~/.zshrc` after you close the editor

This is designed to support a modular, safer layout:

```
~/.zshrc                  # minimal bootstrap loader
~/.zshrc.d/
  00-secrets.zsh          # sensitive vars (ignored by git)
  10-paths.zsh            # PATH, JAVA_HOME, etc.
  20-tools.zsh            # nvm, gcloud, pyenv init
  30-conda.zsh            # conda init block
  40-python-autoenv.zsh   # venv-first, conda fallback
  60-aliases.zsh          # aliases and helper functions
  99-local.zsh            # machine/temporary overrides
```

## Why Use This Tool?

Frequently modifying your `.zshrc` file is common, especially when working across different machines or setting up environments for various projects. While traditional editors like vi or vim are powerful, they can be cumbersome for quick edits. This tool offers several advantages:

1. **User-Friendly Editing**: Use VS Code's familiar interface instead of command-line editors.
2. **Quick Environment Variable Setup**: Easily add or modify environment variables, particularly useful for setting up API keys for different services or projects.
3. **Efficient Multi-Machine Management**: Quickly adapt your shell environment when switching between different development machines or cloud environments.
4. **Enhanced Productivity for LLM Usage**: Rapidly configure environment variables needed for various LLM (Large Language Model) projects or API interactions.

## Quick Setup

Execute the following command in your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/adalgu/mac-zshrc-vscode-editor/main/setup.sh | bash
```

This script will:

1. Find your VS Code installation
2. Add VS Code to your PATH in `.zshrc`
3. Add a `zshrc()` function for easy `.zshrc` file editing

After running the script, restart your terminal or run `source ~/.zshrc` to apply the changes.

## Manual Setup

For those who prefer manual configuration:

1. Ensure VS Code is in your PATH:

   ```bash
   export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
   ```

   Add this line to your `.zshrc` file.

2. Enhanced `zshrc()` helper

   The setup script auto-installs the interactive `zshrc()` function. To install/update manually, copy the block between the markers `# >>> mac-zshrc-vscode-editor zshrc (v2) >>>` and `# <<< mac-zshrc-vscode-editor zshrc (v2) <<<` into your `~/.zshrc`.

3. Source your `.zshrc` file:
   ```bash
   source ~/.zshrc
   ```

## Usage

After setup, run `zshrc` and choose indexes to open. Examples:

- `Enter` → open only `~/.zshrc`
- `0 1 3` → open `~/.zshrc` and the 1st and 3rd files from `~/.zshrc.d`
- `A` → open `~/.zshrc` and all `~/.zshrc.d/*.zsh`
- `S` → include `~/.zsh_secrets` if it exists

This makes it easy to:

- Add new environment variables or modify existing ones
- Set up API keys for different services
- Configure aliases for frequently used commands
- Adjust your PATH or other environment settings

## Troubleshooting

If VS Code is not found, the setup script will prompt you to enter the path manually. Ensure you provide the correct path to the VS Code executable.

### Security note

Never commit secrets. Store API tokens in `~/.zsh_secrets` with restrictive permissions:

```bash
chmod 600 ~/.zsh_secrets
```

## Contributing

Feel free to open issues or submit pull requests if you have suggestions for improvements or additional features.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
