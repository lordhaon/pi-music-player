# 🎵 Raspberry Pi Music Stream Player - Easy Install

## One-Command Installation

Transform your Raspberry Pi into a web-controlled music streaming system in minutes!

### ✨ Features
- 🌐 Web-based control interface
- 🔊 Volume control
- 🔒 Password-protected settings
- 📱 Mobile-friendly interface  
- 🎨 Custom location names
- 🔄 Easy stream URL changes
- 🚀 Works on Pi 4 & Pi 5

---

## 📋 Quick Start (3 Steps)

### Step 1: Prepare Your Pi

Flash Raspberry Pi OS Lite to an SD card and boot up your Pi. Make sure it's connected to your network and you can SSH into it.

### Step 2: Download & Install

SSH into your Pi, then run these commands:

```bash
# Download the installer package
wget https://github.com/YOUR-REPO/pimusic/archive/main.zip
unzip main.zip
cd pimusic-main

# Run the installer
chmod +x install.sh
./install.sh
```

**Or if you have the files already:**

```bash
# Put all files in a folder, then:
chmod +x install.sh
./install.sh
```

The installer will:
- ✅ Update your system
- ✅ Install all required software
- ✅ Detect your audio hardware
- ✅ Configure everything automatically
- ✅ Give you the web address to access

### Step 3: Access Your Player

After installation completes, open a web browser and go to:

```
http://YOUR-PI-IP/music/
```

Complete the first-time setup:
1. Enter a location name (e.g., "Kitchen", "Living Room")
2. Enter your stream URL
3. Create a password (only needed for settings)

That's it! Click **Play** and enjoy! 🎉

---

## 🔧 Manual Installation (If Needed)

If you prefer manual installation or the script doesn't work:

### 1. Update & Install Packages
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y mpv php apache2 libapache2-mod-php socat
```

### 2. Create Web Directory
```bash
sudo mkdir -p /var/www/html/music
sudo chown www-data:www-data /var/www/html/music
sudo chmod 755 /var/www/html/music
```

### 3. Copy Files
```bash
sudo cp index.html control.php config.json /var/www/html/music/
sudo chown www-data:www-data /var/www/html/music/*
sudo chmod 644 /var/www/html/music/index.html
sudo chmod 644 /var/www/html/music/control.php
sudo chmod 666 /var/www/html/music/config.json
```

### 4. Configure Permissions
```bash
echo "www-data ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/music-player
sudo chmod 440 /etc/sudoers.d/music-player
```

### 5. Detect Audio Device
```bash
aplay -l
```

Look for your audio device and note the card name.

### 6. Update control.php

Edit `/var/www/html/music/control.php` and find the line with `--audio-device=`:

**For USB Audio:**
```
--audio-device=alsa/plughw:CARD=Device,DEV=0
```

**For HDMI (Pi 5):**
```
--audio-device=alsa/plughw:CARD=vc4hdmi0,DEV=0
```

**For 3.5mm jack (Pi 4):**
```
--audio-device=alsa/plughw:CARD=Headphones,DEV=0
```

### 7. Start Apache
```bash
sudo systemctl enable apache2
sudo systemctl restart apache2
```

### 8. Access Web Interface
```bash
hostname -I  # Get your IP address
```

Open browser to: `http://YOUR-IP/music/`

---

## 🎛️ Audio Configuration

### Raspberry Pi 5
The Pi 5 **does not have a 3.5mm headphone jack**. You can use:
- **HDMI audio** (through your monitor/TV)
- **USB audio adapter** ($5-10 on Amazon)

The installer will automatically detect and configure whichever you have connected.

### Raspberry Pi 4
Has built-in 3.5mm jack. The installer will detect it automatically.

---

## 📁 Required Files

Make sure you have these files before installing:

- `install.sh` - Automated installer
- `index.html` - Web interface
- `control.php` - Backend controller
- `config.json` - Configuration template

---

## 🔑 Using Your Player

### Daily Use (No Password Required)
1. Open `http://your-pi-ip/music/`
2. Click **Play** to start music
3. Use **volume slider** to adjust
4. Click **Stop** to pause

### Changing Settings (Password Required)
1. Click the **⚙️ gear icon**
2. Enter your password
3. Change stream URL or location name
4. Click **Save**

### Forgot Password?
```bash
ssh into-your-pi
sudo rm /var/www/html/music/.auth.json
```
Refresh the web page - you'll get first-time setup again.

---

## 🎵 Finding Stream URLs

Most internet radio stations provide stream URLs. Look for:
- M3U or PLS playlist files
- Direct stream URLs (usually ending in .mp3 or no extension)

**Example RadioJar streams:**
If you have a `.pls` file like:
```
http://stream.radiojar.com/XXXXXX.pls
```

Download it and look inside for the real URL:
```bash
curl http://stream.radiojar.com/XXXXXX.pls
```

Use the `File1=` URL in your player.

**Popular free streams to try:**
- SomaFM Groove Salad: `http://ice1.somafm.com/groovesalad-128-mp3`
- Radio Paradise: `http://stream.radioparadise.com/aac-320`

---

## 🆘 Troubleshooting

### Can't access web interface
```bash
# Check Apache is running
sudo systemctl status apache2

# Restart Apache
sudo systemctl restart apache2

# Check firewall
sudo ufw status
```

### No audio
```bash
# Test speaker
speaker-test -t wav -c 2

# Check audio devices
aplay -l

# Check if MPV is running
pgrep -f mpv
```

### Volume slider doesn't work
```bash
# Check socket exists
ls -la /tmp/mpv-socket

# Check socat is installed
which socat

# Reinstall if needed
sudo apt install -y socat
```

### Stream won't play
```bash
# Test stream directly
mpv YOUR-STREAM-URL

# Check control.php logs
sudo tail -f /var/log/apache2/error.log
```

---

## 🎁 Bonus: Auto-Start on Boot

Want music to start automatically when Pi boots?

The installer will ask if you want this. If you want to add it later:

```bash
sudo nano /etc/systemd/system/music-stream.service
```

Paste:
```ini
[Unit]
Description=Music Stream Player
After=network.target sound.target

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c 'URL=$(cat /var/www/html/music/config.json | grep stream_url | cut -d\" -f4); mpv --no-video --audio-device=alsa/plughw:CARD=Device,DEV=0 --volume=70 --input-ipc-server=/tmp/mpv-socket "$URL" && chmod 666 /tmp/mpv-socket'
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable it:
```bash
sudo systemctl daemon-reload
sudo systemctl enable music-stream.service
sudo systemctl start music-stream.service
```

---

## 💡 Tips

- **Bookmark the URL** on your phone's home screen for quick access
- **Use short location names** - they display better on mobile
- **Test your stream URL** in VLC or mpv before adding to player
- **Set static IP** on your router so the URL doesn't change

---

## 🚀 Advanced

### Multiple Pis
Install on multiple Pis with different location names:
- Kitchen Pi: "Kitchen Radio"
- Garage Pi: "Workshop Tunes"
- Each gets its own stream and password

### Stream from Spotify/Bluetooth
Use `spotifyd` or `bluez-alsa` to route Spotify/Bluetooth through the Pi's audio output.

### Add LCD Display
Connect a small LCD to show "Now Playing" info from MPV.

---

## 📝 License

Free to use, modify, and share. No warranty provided.

---

## 🎉 Enjoy Your Music!

Questions? Issues? Open a GitHub issue or check the troubleshooting section.

Happy streaming! 🎵
