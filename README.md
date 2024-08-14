# NetWarn 🚀

![Perl Icon](https://img.shields.io/badge/Perl-%23F5DEB3?style=for-the-badge&logo=perl&logoColor=000000) ![Network Icon](https://img.shields.io/badge/Network-%231DA1F2?style=for-the-badge&logo=network&logoColor=ffffff) ![Security Icon](https://img.shields.io/badge/Security-%23FF4F4F?style=for-the-badge&logo=security&logoColor=ffffff) ![Terminal Icon](https://img.shields.io/badge/Terminal-%231d1f21?style=for-the-badge&logo=gnome-terminal&logoColor=00bfae) ![Telegram Icon](https://img.shields.io/badge/Telegram-%231DA1F2?style=for-the-badge&logo=telegram&logoColor=ffffff)

**NetWarn** is a sophisticated Perl script designed to enhance your network security by scanning server ports and sending real-time alerts via Telegram. Tailored for IT professionals and businesses aiming to fortify their network monitoring and security protocols.

---

## 🎯 Features

- **🔍 Single & Bulk Scanning:** Effortlessly scan individual servers or multiple servers listed in a file.
- **📲 Telegram Notifications:** Receive detailed, real-time updates about open ports directly on Telegram.
- **⏱️ Customizable Intervals:** Adjust scan intervals to suit your monitoring needs (default is 24 hours).
- **🌈 Color-Coded Output:** Enjoy clear, color-enhanced terminal output for easy readability.

---

## 🚀 Why NetWarn?

- **⚡ Real-Time Monitoring:** Quickly identify open ports and potential security vulnerabilities on your servers.
- **🔧 Flexible Configuration:** Customize your scan settings to fit your specific requirements.
- **📈 Easy Integration:** Receive updates in your Telegram chat, minimizing the need for constant terminal checks.
- **🔍 Comprehensive Coverage:** Detailed port descriptions and automatic recurring scans ensure thorough monitoring.

---

## 📦 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/netwarn.git
cd netwarn
```

### 2. Install Required Perl Modules

```bash
cpan IO::Socket::INET
cpan Getopt::Long
cpan Time::HiRes
cpan LWP::UserAgent
cpan JSON
```

---

## 🛠️ Usage

### Command-Line Options

- `-s <server>`: Scan a single server.
- `-f <file>`: Scan servers from a file (one per line).
- `-i <interval>`: Set scan interval in seconds (default is 86400 seconds).

### Examples

- **Single Server Scan:**

  ```bash
  perl netwarn.pl -s example.com
  ```

- **Bulk Scan from File:**

  ```bash
  perl netwarn.pl -f servers.txt
  ```

- **Custom Interval Scan:**

  ```bash
  perl netwarn.pl -f servers.txt -i 3600
  ```

---

## ⚙️ Configuration

- **Telegram Bot Setup:**

  Update your Telegram bot token and chat ID in the script:

  ```perl
  my $TELEGRAM_BOT_TOKEN = 'your_bot_token';
  my $TELEGRAM_CHAT_ID   = 'your_chat_id';
  ```

- **Port Descriptions:**

  Modify the `%port_descriptions` hash to update or add port descriptions as needed.

---

## 🖼️ Example Output

### Terminal Output

```plaintext
[i] Scanning server: example.com
[+] Port 80 (HTTP) is open.
[+] Port 443 (HTTPS) is open.
[-] No other open ports found on example.com.
```

### Telegram Notification

```plaintext
[info] : Scanning server: example.com

[+] Port 80: HTTP
[+] Port 443: HTTPS

[+] No other open ports found.
```

### Upcoming Scan Notification

```plaintext
[+] Next scan in 23 hours, 45 minutes, 30 seconds
```

---

## 📢 Note

**NetWarn** is an educational project. For customization requests or specific tool requirements, please reach out to me directly.

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 👤 Author

**Lunar Lumos**  
[Contact Me](https://fb.com/LunarLumos) | [GitHub Profile](https://github.com/LunarLumos)

---
