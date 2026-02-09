# 🎵 Raspberry Pi Music Stream Player

A simple, elegant web-based music streaming system for Raspberry Pi. Control your internet radio streams from any device on your network with a beautiful, mobile-friendly interface.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Raspberry%20Pi-red.svg)
![PHP](https://img.shields.io/badge/PHP-8.4-777BB4.svg)

## ✨ Features

- 🌐 **Web-Based Control** - Access from any device on your network
- 🎚️ **Volume Control** - Smooth, responsive volume slider
- 🔒 **Secure Settings** - Password-protected configuration
- 📱 **Mobile-Friendly** - Works great on phones and tablets
- 🎨 **Custom Names** - Set location names for multiple devices
- 🔄 **Easy Setup** - One-command installation
- 🚀 **Pi 4 & Pi 5** - Works on both models
- 🔊 **Multiple Audio** - USB, HDMI, or 3.5mm output

## 🎬 Quick Start

### One-Command Installation

```bash
# Download the project
git clone https://github.com/YOUR-USERNAME/pi-music-player.git
cd pi-music-player

# Run the installer
chmod +x install.sh
./install.sh
```

That's it! The installer will:
- ✅ Detect your Pi model and audio hardware
- ✅ Install all required packages
- ✅ Configure everything automatically
- ✅ Give you the web address to access

After installation, open your browser to `http://YOUR-PI-IP/music/` and enjoy!

## 🔧 Requirements

- Raspberry Pi 4 or 5
- Raspberry Pi OS (Lite or Desktop)
- Network connection
- Audio output (USB adapter, HDMI, or 3.5mm jack)
- Internet radio stream URL

## 📋 Manual Installation

If you prefer to install manually, see [INSTALL.md](INSTALL.md) for detailed step-by-step instructions.

## 🎵 How It Works

1. **Access the web interface** from any device on your network
2. **Click Play** to start streaming
3. **Adjust volume** with the slider
4. **Click the gear icon** to change settings (requires password)

## 🆘 Troubleshooting

See [INSTALL.md](INSTALL.md) for comprehensive troubleshooting guide.

## 📝 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

Built with MPV, Apache, PHP, and socat.

---

**Made with ❤️ for the Raspberry Pi community**

🎵 Happy Streaming! 🎵
