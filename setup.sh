#!/bin/bash

# Function to find VS Code path
find_vscode_path() {
    local vscode_path=$(which code)
    if [ -z "$vscode_path" ]; then
        echo "VS Code not found in PATH. Please enter the full path to VS Code:"
        read vscode_path
        if [ ! -f "$vscode_path" ]; then
            echo "Invalid path. VS Code not found at $vscode_path"
            return 1
        fi
    fi
    echo $vscode_path
}

# Get VS Code path
vscode_path=$(find_vscode_path)
if [ $? -ne 0 ]; then
    exit 1
fi

# Extract the directory path
vscode_dir=$(dirname $(dirname "$vscode_path"))

# Construct the export PATH command
export_command="export PATH=\"\$PATH:$vscode_dir/Resources/app/bin\""

# Function to edit .zshrc
zshrc_function='
# Function to edit .zshrc in VS Code and apply changes
function zshrc() {
    code ~/.zshrc
    echo "Press Enter after you'"'"'ve finished editing and saved the file."
    read
    source ~/.zshrc
    echo ".zshrc has been updated and sourced."
}'

# Check if .zshrc exists, if not create it
touch ~/.zshrc

# Check if export PATH already exists in .zshrc
if ! grep -q "$export_command" ~/.zshrc; then
    echo -e "\n$export_command" >> ~/.zshrc
    echo "Added VS Code to PATH in .zshrc"
else
    echo "VS Code PATH already exists in .zshrc"
fi

# Check if zshrc function already exists in .zshrc
if ! grep -q "function zshrc()" ~/.zshrc; then
    echo -e "\n$zshrc_function" >> ~/.zshrc
    echo "Added zshrc function to .zshrc"
else
    echo "zshrc function already exists in .zshrc"
fi

echo "Setup complete. Please restart your terminal or run 'source ~/.zshrc' to apply changes."