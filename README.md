# 3GPP File Management Scripts

This repository contains three scripts designed for managing, downloading, and summarizing 3GPP data efficiently.

## Files in the Repository

### 1. `download.sh`
This Bash script automates the downloading of files from an FTP server (default: `ftp://ftp.3gpp.org`). It supports parallel transfers and configurable options for the server, remote directory, local storage path, and log file.

#### Usage:
```bash
./download.sh [-s ftp_server] [-r remote_dir] [-l local_dir] [-o log_file]
```
- `-s` : FTP server URL (default: `ftp://ftp.3gpp.org`)
- `-r` : Remote directory to fetch files from
- `-l` : Local directory to store the downloaded files
- `-o` : Log file to store download logs

### 2. `clean_files.sh`
This script cleans up a directory by deleting files that do not match a predefined set of allowed extensions (`pdf`, `zip`, `docx`, `ppt`, `xlsx`, `doc`, `pptx`). It utilizes parallel processing for efficiency.

#### Usage:
```bash
./clean_files.sh
```
- Prompts the user for a folder path.
- Deletes files that do not match the allowed extensions.
- Supports parallel execution for speed.



