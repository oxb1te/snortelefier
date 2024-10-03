#!/bin/bash

# Танзимотӣ барои Snortelefier
#
# Snortelefier (Snort Telegram Notifier - Огоҳидиҳандаи телеграммии Snort): 
#   Барномаи скриптии соддаи bash барои фиристодани огоҳиномаҳои Snort тавассути 
#   Telegram Bot ба корбар, агар файлҳои логии Snort вуҷуд дошта бошанд.
# Репозиторий: 
#   https://github.com/oxb1te/snortelefier
# Муаллиф: 
#   oxbyte (https://github.com/oxb1te)

if ! command -v inotifywatch &> /dev/null; then
    echo "[x] - Фармони inotifywatch барои пайгирии тағйирот дар файли лог ёфт нашуд. Лутфан пакети \"inotify-tools\"-ро насб кунед."
    return
fi

ENV_FILE=".env"

# - Функсия барои дархости маълумот аз истифодабаранда -
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
        echo "CHAT_ID=\"$(prompt_input 'Ворид кунед CHAT ID-и Telegram-и худро (аҳамият дорад)' '')\""
        echo "TOKEN=\"$(prompt_input 'Ворид кунед TOKEN-и Telegram Bot-и худро (аҳамият дорад)' '')\""
        echo "CHECK_INTERVAL=\"$(prompt_input 'Муддати санҷиш дар сония' '10')\""
        echo "RATE_LIMIT=\"$(prompt_input 'Ҳадди нарх барои огоҳиномаҳо' '5')\""
        echo "RATE_WINDOW=\"$(prompt_input 'Вакти нарх дар сония' '60')\""
        echo "ALERT_COUNT=\"0\""
        echo "LAST_ALERT_TIME=\"0\""
        echo "BLOCK_DURATION=\"$(prompt_input 'Муддати манъ кардан дар сония' '300')\""
        echo "BLOCK_UNTIL=\"0\""
    } > "$ENV_FILE"

    printf "[*] - Файли .env дар %s сохта шуд\n" "$PWD/$ENV_FILE"
}

restrict_permissions() {
    echo "[*] - Ҳуқуқи файли .env танҳо барои root маҳдуд карда мешавад..."
    sudo chown root:root "$ENV_FILE" && sudo chmod 400 "$ENV_FILE"
    printf "[*] - Ҳуқуқҳо бо муваффақият маҳдуд карда шуданд. ТАНҲО ROOT ФАЙЛИ .env-РО ИВАЗ КАРДА МЕТАВОНАД!\n"
}

compile_script() {
    echo "[*] - Скрипт бо истифода аз shc компилятсия мешавад..."
    if ! command -v shc &> /dev/null; then
        echo "[x] - Компилятори shc пайдо наёфт. Лутфан аввал онро насб кунед."
        return
    fi
    shc -H -f snortelefier -o snortelefier_compiled
    printf "[*] - Скрипт бо муваффақият ҳамчун snortelefier_compiled компилятсия шуд\n"
}

add_to_systemd() {
    SYSTEMD_PATH="/etc/systemd/system/snortelefier.service"
    
    echo "[Unit]
Description=Огоҳидиҳандаи телеграммии Snort аз они oxbyte
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
    printf "[*] - Даемон барои systemd бо муваффақият илова шуд.\n"
}

# - Асосӣ - 
create_env_file

read -rp "Оё шумо мехоҳед ҳуқуқи файли .env-ро маҳдуд кунед? (y/n) " restrict
if [[ "$restrict" =~ [Yy] ]]; then
    restrict_permissions
else
    echo "[*] - Маҳдудкунии ҳуқуқи файл .env гузаронда шуд."
fi

read -rp "Оё шумо мехоҳед скриптро бо shc компилятсия кунед? (y/n) " compile
if [[ $compile =~ [Yy] ]]; then
    compile_script
else
    echo "[*] - Компилятсия гузаронда шуд."
fi

read -rp "Оё шумо мехоҳед скриптро ба systemd илова кунед? (Y/n) " add_systemd
if [[ $add_systemd =~ [Yy] ]] || [[ $add_systemd == " " ]]; then
    add_to_systemd
else
    echo "[*] - Функсияи systemd гузаронда шуд."
fi

printf "[*] - Танзимот ба итмом расид!\n"
