#!/bin/bash

# Define allowed extensions (case insensitive)
KEEP_EXTENSIONS=("pdf" "zip" "docx" "ppt" "xlsx" "doc" "pptx" "rtf")

# Ask the user for the folder to scan
echo "Please enter the path to the folder you want to clean up:"
read folder_path

# Check if the provided folder exists
if [ ! -d "$folder_path" ]; then
    echo "The provided path is not a valid directory. Exiting."
    exit 1
fi

# Check if we have sudo privileges
HAS_SUDO=0
if sudo -v &>/dev/null; then
    HAS_SUDO=1
fi

# Function to delete files
delete_files() {
    local files=("$@")
    echo "[$(date +%T)] PID $$: Deleting ${#files[@]} files..."
    if [[ "$HAS_SUDO" -eq 1 ]]; then
        printf '%s\0' "${files[@]}" | sudo xargs -0 -P 40 -n 100 rm -f 2>/dev/null || echo "Failed to delete some files."
    else
        printf '%s\0' "${files[@]}" | xargs -0 -P 40 -n 100 rm -f 2>/dev/null || echo "Failed to delete some files."
    fi
}

export -f delete_files
export HAS_SUDO

# Find and delete unwanted files in parallel
find "$folder_path" -type f | parallel  -j50 --pipe '
    files=()
    while IFS= read -r file; do
        ext="${file##*.}"
        ext_lower=$(echo "$ext" | tr "[:upper:]" "[:lower:]")

        allowed=0
        for e in '"${KEEP_EXTENSIONS[*]}"'; do
            if [[ "$ext_lower" == "$e" ]]; then
                allowed=1
                break
            fi
        done

        if [[ $allowed -eq 0 ]]; then
            files+=("$file")
            echo "PID $$ processing: $file" >> parallel.log
        fi
    done

    if [[ ${#files[@]} -gt 0 ]]; then
        delete_files "${files[@]}"
    fi
'

echo "Cleanup completed!"