#!/usr/bin/env python3

import os
import sys
from collections import defaultdict
from datetime import datetime

def get_file_summary(directory):
    file_summary = defaultdict(lambda: {"count": 0, "size": 0})

    # Walk through the directory and subdirectories
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            ext = os.path.splitext(file)[1] or "[No Extension]"
            file_summary[ext]["count"] += 1
            file_summary[ext]["size"] += os.path.getsize(file_path)

    return file_summary

def write_summary_to_file(file_summary, total_size, directory):
    # Get the current timestamp for when the summary is generated
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Define the file where summary will be stored
    summary_file = "file_summary.txt"

    # Open the file in append mode (this will add new data instead of overwriting)
    with open(summary_file, "a") as f:
        f.write(f"\nSummary Generated at: {timestamp}\n")
        f.write(f"File Summary for Directory: {directory}\n")
        f.write("=" * 40 + "\n")
        f.write(f"{'File Type':<15}{'Count':<10}{'Total Size (GB)'}\n")
        f.write("=" * 40 + "\n")
        
        for ext, data in sorted(file_summary.items(), key=lambda x: x[1]["size"], reverse=True):
            size_in_gb = data["size"] / (1024 * 1024 * 1024)  # Convert bytes to GB
            f.write(f"{ext:<15}{data['count']:<10}{size_in_gb:.2f} GB\n")

        f.write("=" * 40 + "\n")
        total_size_in_gb = total_size / (1024 * 1024 * 1024)  # Convert total size to GB
        f.write(f"Total Size: {total_size_in_gb:.2f} GB\n")

def main():
    # Get directory from command-line argument or use current directory
    directory = sys.argv[1] if len(sys.argv) > 1 else "."

    if not os.path.isdir(directory):
        print(f"Error: '{directory}' is not a valid directory.")
        sys.exit(1)

    print(f"Scanning directory: {directory}\n")
    file_summary = get_file_summary(directory)

    total_size = 0  # To keep track of the total size of all files

    # Calculate total size and prepare the summary data
    for ext, data in file_summary.items():
        total_size += data["size"]

    # Write the results to a summary file
    write_summary_to_file(file_summary, total_size, directory)

    print(f"Summary saved to 'file_summary.txt'")

if __name__ == "__main__":
    main()
