#!/bin/bash

shopt -s dotglob

DOTFILES_DIR="$HOME/dot"
FORCE=false

# --- Parse arguments ---
if [[ "$1" == "--force" ]]; then
    FORCE=true
fi

# --- Loop over everything in current dir ---
for ITEM in ./*; do
    BASENAME="${ITEM#./}"

    # --- Skip specific files ---
    if [[ "$BASENAME" == ".git" || "$BASENAME" == "set-environment.sh" ]]; then
        continue
    fi

    # --- Handle .config subdirectories ---
    if [[ "$BASENAME" == ".config" ]]; then
        for CONFIG_ITEM in "$ITEM"/*; do
            TARGET="$HOME/${CONFIG_ITEM#./}"
            SOURCE="$DOTFILES_DIR/${CONFIG_ITEM#./}"

            # Prevent recursive link
            if [[ "$TARGET" -ef "$SOURCE" ]]; then
                echo "Skipped: $TARGET (would create recursive link)"
                continue
            fi

            if [[ -e "$TARGET" || -L "$TARGET" ]]; then
                if $FORCE; then
                    rm -rf "$TARGET"
                    ln -s "$SOURCE" "$TARGET"
                    echo "[FORCED] Linked: $SOURCE → $TARGET"
                else
                    echo "Skipped: $TARGET (already exists)"
                fi
            else
                ln -s "$SOURCE" "$TARGET"
                echo "Linked: $SOURCE → $TARGET"
            fi
        done
        continue
    fi

    # --- Handle regular files/folders ---
    TARGET="$HOME/$BASENAME"
    SOURCE="$DOTFILES_DIR/$BASENAME"

    if [[ "$TARGET" -ef "$SOURCE" ]]; then
        echo "Skipped: $TARGET (would create recursive link)"
        continue
    fi

    if [[ -e "$TARGET" || -L "$TARGET" ]]; then
        if $FORCE; then
            rm -rf "$TARGET"
            ln -s "$SOURCE" "$TARGET"
            echo "[FORCED] Linked: $SOURCE → $TARGET"
        else
            echo "Skipped: $TARGET (already exists)"
        fi
    else
        ln -s "$SOURCE" "$TARGET"
        echo "Linked: $SOURCE → $TARGET"
    fi
done
