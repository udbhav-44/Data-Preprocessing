#!/bin/bash

# Set default values
FTP_SERVER="ftp://ftp.3gpp.org"
REMOTE_DIR="/"
LOCAL_DIR="/git_folder/udbhav/DATA"
LOG_FILE="/git_folder/udbhav/3gpp_download.log"

# Parse command-line arguments
while getopts "s:r:l:o:" opt; do
  case ${opt} in
    s ) FTP_SERVER=$OPTARG ;;
    r ) REMOTE_DIR=$OPTARG ;;
    l ) LOCAL_DIR=$OPTARG ;;
    o ) LOG_FILE=$OPTARG ;;
    * ) echo "Usage: $0 [-s ftp_server] [-r remote_dir] [-l local_dir] [-o log_file]"; exit 1 ;;
  esac
done

# Run lftp with configured settings
lftp -c "set net:timeout 10; \
        set net:max-retries 2; \
        set net:reconnect-interval-base 5; \
        set net:reconnect-interval-multiplier 1; \
        set mirror:parallel-transfer-count 120; \
        set xfer:use-temp-file yes; \
        set cmd:trace 1; \
        open $FTP_SERVER; \
        mirror -c --use-pget-n=80 -P 120 --verbose --only-newer $REMOTE_DIR $LOCAL_DIR" | tee -a "$LOG_FILE"
