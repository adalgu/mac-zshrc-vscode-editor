# Mac .zshrc VS Code Editor

This project provides a simple and efficient way to edit your `.zshrc` file using Visual Studio Code on macOS.

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

2. Add the `zshrc()` function to your `.zshrc`:

   ```bash
   # Function to edit .zshrc in VS Code and apply changes
   function zshrc() {
       code ~/.zshrc
       echo "Press Enter after you've finished editing and saved the file."
       read
       source ~/.zshrc
       echo ".zshrc has been updated and sourced."
   }
   ```

3. Source your `.zshrc` file:
   ```bash
   source ~/.zshrc
   ```

## Usage

After setup, simply type `zshrc` in your terminal to edit your `.zshrc` file with VS Code. This makes it easy to:

- Add new environment variables or modify existing ones
- Set up API keys for different services
- Configure aliases for frequently used commands
- Adjust your PATH or other environment settings

## Troubleshooting

If VS Code is not found, the setup script will prompt you to enter the path manually. Ensure you provide the correct path to the VS Code executable.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions for improvements or additional features.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
