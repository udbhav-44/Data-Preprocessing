#!/bin/bash

# Ask the user for the folder to scan
echo "Enter the path to the folder containing ZIP files:"
read folder_path

# Check if the provided folder exists
if [ ! -d "$folder_path" ]; then
    echo "Invalid directory. Exiting."
    exit 1
fi

# Get number of CPU cores and set max parallel jobs
CPU_CORES=$(nproc) # Auto-detect number of cores
MAX_JOBS=$((CPU_CORES * 4)) # Utilize full CPU potential

# Function to unzip and delete files
unzip_and_delete() {
    local zip_file="$1"
    local dir
    dir=$(dirname "$zip_file")

    echo "[PID $$] Extracting: $zip_file"
    
    # Try using pigz if available (faster extraction)
    if command -v pigz &>/dev/null; then
        unzip -o "$zip_file" -d "$dir" && rm -f "$zip_file"
    else
        unzip -o "$zip_file" -d "$dir" && rm -f "$zip_file"
    fi
    
    echo "[PID $$] Completed: $zip_file"
}

export -f unzip_and_delete

# Find and extract ZIP files in highly parallel mode
find "$folder_path" -type f -iname "*.zip" | nice -n 10 parallel -j "$MAX_JOBS" --no-notice unzip_and_delete {}

echo "Extraction and cleanup completed!"
