#!/bin/bash

# Setup Script for Snortelefier
#
# Snortelefier (Snort Telegram Notifier): 
#   Simple bash script for sending alerts from Snort via Telegram Bot to the user if there are any Snort log files.
# Repository:
#   https://github.com/oxb1te/snortelefier
# Author:
#    oxbyte (https://github.com/oxb1te)

if ! command -v inotifywatch &> /dev/null; then
    echo "[x] - inotifywatch command for tracking changes in log file not found. Please install \"inotify-tools\" package."
    return
fi

ENV_FILE=".env"

# - Function to prompt for user input with a default value -
prompt_input() {
    local prompt="$1"
    local default="$2"
    read -rp "$prompt [$default]: " input
    echo "${input:-$default}"
}

create_env_file() {
    {
        echo "LOGS=\"/var/log/snort/snort.log\""
        echo "MSG_CAPTION=\"\$PWD/snortelefier_msg.txt\""
        echo "CHAT_ID=\"$(prompt_input 'Enter your Telegram Chat ID (critical)' '')\""
        echo "TOKEN=\"$(prompt_input 'Enter your Telegram Bot Token (critical)' '')\""
        echo "CHECK_INTERVAL=\"$(prompt_input 'Check interval in seconds' '10')\""
        echo "RATE_LIMIT=\"$(prompt_input 'Rate limit for alerts' '5')\""
        echo "RATE_WINDOW=\"$(prompt_input 'Rate window in seconds' '60')\""
        echo "ALERT_COUNT=\"0\""
        echo "LAST_ALERT_TIME=\"0\""
        echo "BLOCK_DURATION=\"$(prompt_input 'Block duration in seconds' '300')\""
        echo "BLOCK_UNTIL=\"0\""
    } > "$ENV_FILE"

    printf "[*] - .env file created at %s\n" "$PWD/$ENV_FILE"
}

restrict_permissions() {
    echo "[*] - Restricting permissions of the .env file only for root..."
    sudo chown root:root "$ENV_FILE" && sudo chmod 400 "$ENV_FILE"
    printf "[*] - Permissions restricted successfully. ONLY ROOT USER CAN EDIT .env FILE\n"
}

compile_script() {
    echo "[*] - Compiling the script using shc..."
    if ! command -v shc &> /dev/null; then
        echo "[x] - shc compiler not found. Please install it first."
        return
    fi
    shc -H -f snortelefier -o snortelefier_compiled
    printf "[*] - Script compiled successfully as snortelefier_compiled\n"
}

add_to_systemd() {
    SYSTEMD_PATH="/etc/systemd/system/snortelefier.service"
    
    echo "[Unit]
Description=Snort Telegram Notifier by Oxbyte
After=network.target

[Service]
ExecStart=$PWD/snortelefier
WorkingDirectory=$PWD
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=snortelefier
Restart=on-failure

[Install]
WantedBy=multi-user.target" | sudo tee "$SYSTEMD_PATH" > /dev/null

    sudo systemctl daemon-reload
    sudo systemctl enable snortelefier
    printf "[*] - Service added to systemd successfully.\n"
}

# - Main - 
create_env_file

read -rp "Do you want to restrict permissions of the .env file? (y/n) " restrict
if [[ "$restrict" =~ [Yy] ]]; then
    restrict_permissions
else
    echo "[*] - Skipping permission restriction."
fi

read -rp "Do you want to compile the script using shc? (y/n) " compile
if [[ $compile =~ [Yy] ]]; then
    compile_script
else
    echo "[*] - Skipping compilation."
fi

read -rp "Do you want to add the script to systemd? (Y/n) " add_systemd
if [[ $add_systemd =~ [Yy] ]] || [[ $add_systemd == " " ]]; then
    add_to_systemd
else
    echo "[*] - Skipping systemd setup."
fi

printf "[*] - Setup completed!\n"
