#!/usr/bin/env sh
# shellcheck shell=sh
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# mount_bandicoot.sh
#
# This script creates a local mount point and mounts a CIFS/Samba share
# at //data.ucdenver.pvt/dept/SOM/DBMI/<mount_name> into ~/mnt/<mount_name>.
# It auto-detects macOS vs. Linux, installs cifs-utils on Linux if needed,
# verifies VPN/network access, and works under any POSIX shell
# (sh, bash, zsh, dash, etc.).
# ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

set -eu
# -e: exit immediately on any error
# -u: treat unset variables as an error

echo "This script mounts a CU Anschutz Isilon CIFS/SMB share under ~/mnt."
echo "It will:"
echo "  1) Ask for a mount/share name (used for both remote and local paths)"
echo "  2) Verify network/VPN reachability"
echo "  3) Optionally ask for local file/dir permission mode (default: 775)"
echo "  4) Mount //data.ucdenver.pvt/dept/SOM/DBMI/<name> to ~/mnt/<name>"
echo ""

# Prompt for mount/share name used for both remote and local paths.
printf "Mount/share name (e.g., LabName, etc.): " >/dev/tty
read -r MOUNT_NAME </dev/tty || MOUNT_NAME=""
if [ -z "$MOUNT_NAME" ]; then
    echo "✗ Mount/share name cannot be empty." >&2
    exit 1
fi
case "$MOUNT_NAME" in
    */* | "." | "..")
        echo "✗ Mount name cannot contain '/' and cannot be '.' or '..'." >&2
        exit 1
        ;;
esac

printf "Local file/dir mode [775]: " >/dev/tty
read -r LOCAL_MODE </dev/tty || LOCAL_MODE=""
if [ -z "$LOCAL_MODE" ]; then
    LOCAL_MODE="775"
fi
case "$LOCAL_MODE" in
    [0-7][0-7][0-7])
        ;;
    *)
        echo "✗ Permission mode must be a 3-digit octal value like 775." >&2
        exit 1
        ;;
esac
OCTAL_MODE="0$LOCAL_MODE"

# Remote share location (UNC path)
SHARE="//data.ucdenver.pvt/dept/SOM/DBMI/$MOUNT_NAME"
# Local directory where the share will be mounted
MOUNT_POINT="$HOME/mnt/$MOUNT_NAME"
# Strip leading '//' and everything after the first '/'
HOST="${SHARE#//}"
HOST="${HOST%%/*}"

print_share_path_tips() {
    echo "Tips to troubleshoot network/share path issues:" >&2
    echo "  • Confirm VPN is connected and retry." >&2
    echo "  • Verify the share name and case are correct: $MOUNT_NAME" >&2
    echo "  • Verify this exact share exists and you have access: $SHARE" >&2
    echo "  • If unsure, ask Isilon admins for the exact share path." >&2
}

# ────────────────────────────────────────────────────────────────────────────
# 1) Ensure the mount directory exists
# ────────────────────────────────────────────────────────────────────────────
if [ ! -d "$MOUNT_POINT" ]; then
    echo "→ Creating mount point directory: $MOUNT_POINT"
    mkdir -p "$MOUNT_POINT"
    # mkdir -p will also create any missing parent directories
fi

# ────────────────────────────────────────────────────────────────────────────
# 2) Extract host from the UNC path and verify network/VPN access
# ────────────────────────────────────────────────────────────────────────────
echo "→ Checking network reachability to $HOST..."
# Try a single ping with 1s timeout; adjust flags if your ping differs
if ! ping -c 1 -W 1 "$HOST" >/dev/null 2>&1; then
    echo "✗ Unable to reach $HOST. Please ensure you're connected to VPN or network." >&2
    print_share_path_tips
    exit 1
fi

# ────────────────────────────────────────────────────────────────────────────
# 3) Detect operating system and perform mount
# ────────────────────────────────────────────────────────────────────────────
OS="$(uname)"
case "$OS" in
    Darwin)
        # macOS branch
        echo "→ Detected macOS (Darwin). Using mount_smbfs."
        #
        # mount_smbfs is the built-in macOS SMB client.
        # It will prompt you for credentials if required,
        # or use your current login keychain.
        #
        if ! mount_smbfs -d "$OCTAL_MODE" -f "$OCTAL_MODE" "$SHARE" "$MOUNT_POINT"; then
            echo "✗ Failed to mount $SHARE at $MOUNT_POINT." >&2
            print_share_path_tips
            exit 1
        fi
        ;;

    Linux)
        # Linux branch
        echo "→ Detected Linux. Verifying cifs-utils (mount.cifs) is installed..."
        #
        # mount.cifs is provided by the cifs-utils package.
        # If it's missing, we detect your package manager and install it.
        #
        if ! command -v mount.cifs >/dev/null 2>&1; then
            echo "→ cifs-utils not found. Attempting installation..."
            if command -v apt-get >/dev/null 2>&1; then
                echo "   • Using apt-get to install cifs-utils"
                sudo apt-get update
                sudo apt-get install -y cifs-utils
            elif command -v yum >/dev/null 2>&1; then
                echo "   • Using yum to install cifs-utils"
                sudo yum install -y cifs-utils
            else
                echo "✗ Unsupported package manager. Please install cifs-utils manually." >&2
                exit 1
            fi
        fi

        # Prompt the user for their CIFS username
        printf "Isilon/CIFS username (CU Anschutz username): " >/dev/tty
        read -r CIFS_USERNAME </dev/tty  # read from the terminal, not the script pipe
        if [ -z "$CIFS_USERNAME" ]; then
            echo "✗ Username cannot be empty." >&2
            exit 1
        fi
        if [ -z "$USER" ]; then
            echo "USER not defined, please define" >&2
            exit 1
        fi
        # Mount the share with domainauto for automatic domain selection
        if ! sudo mount -t cifs "$SHARE" "$MOUNT_POINT" \
            -o username="$CIFS_USERNAME",uid="$USER",gid="$USER",domainauto,file_mode="$OCTAL_MODE",dir_mode="$OCTAL_MODE"; then
            echo "✗ Failed to mount $SHARE at $MOUNT_POINT." >&2
            print_share_path_tips
            exit 1
        fi
        ;;

    *)
        # Unsupported OS
        echo "✗ Unsupported operating system: $OS" >&2
        exit 1
        ;;
esac

# ────────────────────────────────────────────────────────────────────────────
# 4) Success message
# ────────────────────────────────────────────────────────────────────────────
echo "✔ Successfully mounted $SHARE at $MOUNT_POINT"
