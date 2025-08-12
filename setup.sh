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

# Check if .zshrc exists, if not create it
touch ~/.zshrc

# Check if export PATH already exists in .zshrc
if ! grep -q "$export_command" ~/.zshrc; then
    echo -e "\n$export_command" >> ~/.zshrc
    echo "Added VS Code to PATH in .zshrc"
else
    echo "VS Code PATH already exists in .zshrc"
fi

# Install or update enhanced zshrc helper (interactive, supports ~/.zshrc.d)
# Remove previous managed block if present, then append fresh block
sed -i '' '/^# >>> mac-zshrc-vscode-editor zshrc (v2) >>>$/,/^# <<< mac-zshrc-vscode-editor zshrc (v2) <<</d' ~/.zshrc

cat <<'ZSHRC_FUNC' >> ~/.zshrc
# >>> mac-zshrc-vscode-editor zshrc (v2) >>>
# Interactive editor for .zshrc and modular files in ~/.zshrc.d
zshrc() {
  local zrc="${ZDOTDIR:-$HOME}/.zshrc"
  local dir="$HOME/.zshrc.d"
  local secrets="$HOME/.zsh_secrets"

  # pick editor
  local editor
  if command -v code >/dev/null 2>&1; then
    editor=(code --wait)
  elif command -v subl >/dev/null 2>&1; then
    editor=(subl -w)
  elif command -v mate >/dev/null 2>&1; then
    editor=(mate -w)
  elif command -v bbedit >/dev/null 2>&1; then
    editor=(bbedit --wait)
  elif [[ -n "$EDITOR" ]]; then
    editor=($EDITOR)
  else
    editor=(nano)
  fi

  # build selectable list from ~/.zshrc.d
  local -a map_paths
  local -i idx=1

  echo "Select files to edit (space-separated). Press Enter for [0] only:"
  printf "[0] %s\n" "$zrc"

  if [[ -d "$dir" ]]; then
    # list *.zsh sorted
    local f
    while IFS= read -r f; do
      [[ -z "$f" ]] && continue
      map_paths[idx]="$f"
      printf "[%d] %s\n" "$idx" "$f"
      ((idx++))
    done < <(command ls -1 "$dir"/*.zsh 2>/dev/null | sort)
  else
    echo "(no $dir present)"
  fi

  [[ -f "$secrets" ]] && echo "[S] $secrets"
  echo "[A] All in ~/.zshrc.d (excludes secrets)"

  local reply
  printf "> "
  IFS=$' \t\n' read -r reply || true
  reply=${reply:-0}

  # collect chosen files
  local -a files=()
  local token
  for token in $reply; do
    case "$token" in
      0) files+="$zrc" ;;
      A|a)
        files+="$zrc"
        local i
        for i in ${(k)map_paths}; do
          files+="${map_paths[i]}"
        done
        ;;
      S|s)
        [[ -f "$secrets" ]] && files+="$secrets" || echo "(no $secrets)"
        ;;
      '' ) ;;
      *)
        if [[ "$token" == <-> ]]; then
          local -i n=$token
          if (( n >= 1 && n < idx )); then
            files+="${map_paths[n]}"
          else
            echo "(skip: invalid index $token)"
          fi
        else
          echo "(skip: unknown token '$token')"
        fi
        ;;
    esac
  done

  # default when only Enter pressed: open main .zshrc
  if (( ${#files[@]} == 0 )); then
    files+="$zrc"
  fi

  # de-duplicate selections
  local -A seen
  local -a unique=()
  local p
  for p in "$files[@]"; do
    [[ -z "$p" ]] && continue
    if [[ -z "${seen[$p]}" ]]; then
      unique+="$p"
      seen[$p]=1
    fi
  done

  # open in editor (wait when supported)
  "${editor[@]}" "$unique[@]"

  # reload main config
  if [[ -f "$zrc" ]]; then
    # shellcheck disable=SC1090
    source "$zrc"
    echo "🔁 .zshrc reloaded."
  fi
}

# convenience
alias zshrcd='${=EDITOR:-code} ~/.zshrc.d'
alias zr='source ~/.zshrc && echo "🔁 reloaded"'
# <<< mac-zshrc-vscode-editor zshrc (v2) <<<
ZSHRC_FUNC

echo "Installed enhanced zshrc() helper. Restart terminal or run 'source ~/.zshrc' to apply."