# Snortelefier - Snort Telegram Notifier

Snortelefier is a simple Bash script designed to send Snort log alerts via a Telegram Bot. It monitors the Snort log file for any new alerts and sends notifications to the user's Telegram account. It's lightweight, fast, and customizable to meet your specific needs.

## Features

- **Real-time Snort log monitoring**: Uses `inotifywait` to track changes in Snort log files.
- **Telegram notifications**: Sends alerts to your Telegram account using a bot.
- **Rate limiting**: Control how often alerts are sent to avoid notification overload.
- **Easy to configure**: Simply set your Telegram bot token and chat ID in a `.env` file.
- **Systemd support**: Optionally add Snortelefier as a systemd service for automatic start on boot.
- **Security focused**: Restrict access to sensitive configuration files to the root user.

## How It Works

Snortelefier works by monitoring your Snort log file using `inotifywait` from the `inotify-tools` package. When the log file is updated (e.g., a new alert is triggered), the script sends the latest log entry as a Telegram message. To prevent spam, rate-limiting is applied based on user-defined thresholds.

## Disclaimer
Snortelefier is provided "as is." The author is not liable for any damages or losses. Use this script responsibly! Unauthorized monitoring, exfiltration of data, or other cyber attacks that this script can assist with may violate laws and regulations. Ensure compliance with applicable legal standards before use!

## Requirements

- **Snort**: Make sure Snort is installed and configured on your system.
- **inotify-tools**: To monitor log file changes.
- **curl**: For sending HTTP requests to Telegram's API.
- **shc** (optional): To compile the script for added security.
- **systemd** (optional): To run Snortelefier as a service.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/oxb1te/snortelefier.git
    cd snortelefier
    ```

2. Install required dependencies:
    ```bash
    sudo apt-get install inotify-tools curl shc -y
    ```

3. Run the setup script:
    ```bash
    ./setup.sh
    ```

4. Configure your `.env` file:
    - You will be prompted to enter your Telegram Bot token and chat ID during the setup process.
    - The `.env` file will be created with default values for log paths, check intervals, and rate limits.
    OR
    - You can edit it manually.

## Example

Here’s an example of what a typical notification might look like:
```
[!] - Hello User!
[!] - Suspicious network activity has been detected on the server!

[*] - Server Time: 03 Oct 2024 10:15:34
Snort Alert: [**] [1:1000001:0] ICMP PING [**] [Classification: Misc activity] [Priority: 3] SRC_IP -> DST_IP
```

## Contributing
Feel free to contribute to this project! If you have any ideas, improvements, or bugs to report, please submit an issue or a pull request.

## License
This project is licensed under the MIT License. See the ![LICENSE](./LICENSE) file for more details.