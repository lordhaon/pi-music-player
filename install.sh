#!/bin/bash

#############################################
# Raspberry Pi Music Stream Player Installer
# One-command setup for Pi 4 or Pi 5
#############################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=================================="
echo "Raspberry Pi Music Stream Player"
echo "Automated Installer"
echo "==================================${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}ERROR: This script should NOT be run as root.${NC}"
   echo "Please run as normal user with sudo privileges."
   exit 1
fi

# Detect Pi model
PI_MODEL=$(cat /proc/device-tree/model 2>/dev/null || echo "Unknown")
echo -e "${BLUE}Detected:${NC} $PI_MODEL"
echo ""

# Step 1: Update system
echo -e "${GREEN}[1/10] Updating system...${NC}"
sudo apt update
sudo apt upgrade -y

# Step 2: Install packages
echo ""
echo -e "${GREEN}[2/10] Installing required packages...${NC}"
sudo apt install -y mpv php apache2 libapache2-mod-php socat

# Step 3: Create web directory
echo ""
echo -e "${GREEN}[3/10] Creating web directory...${NC}"
sudo mkdir -p /var/www/html/music
sudo chown www-data:www-data /var/www/html/music
sudo chmod 755 /var/www/html/music

# Step 4: Copy web files
echo ""
echo -e "${GREEN}[4/10] Installing web interface files...${NC}"
if [ -f "index.html" ] && [ -f "control.php" ] && [ -f "config.json" ]; then
    sudo cp index.html /var/www/html/music/
    sudo cp control.php /var/www/html/music/
    sudo cp config.json /var/www/html/music/
    sudo chown www-data:www-data /var/www/html/music/*
    sudo chmod 644 /var/www/html/music/index.html
    sudo chmod 644 /var/www/html/music/control.php
    sudo chmod 666 /var/www/html/music/config.json
    echo -e "${GREEN}✓ Web files installed${NC}"
else
    echo -e "${RED}ERROR: Required files not found in current directory!${NC}"
    echo "Please ensure index.html, control.php, and config.json are present."
    exit 1
fi

# Step 5: Configure sudo permissions
echo ""
echo -e "${GREEN}[5/10] Configuring permissions...${NC}"
echo "www-data ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/music-player > /dev/null
sudo chmod 440 /etc/sudoers.d/music-player
echo -e "${GREEN}✓ Permissions configured${NC}"

# Step 6: Start Apache
echo ""
echo -e "${GREEN}[6/10] Starting Apache web server...${NC}"
sudo systemctl enable apache2
sudo systemctl restart apache2
echo -e "${GREEN}✓ Apache started${NC}"

# Step 7: Detect and configure audio
echo ""
echo -e "${GREEN}[7/10] Detecting audio devices...${NC}"
aplay -l

# Check for USB audio
if aplay -l | grep -q "USB Audio"; then
    AUDIO_DEVICE="USB Audio Device"
    AUDIO_CONFIG="alsa/plughw:CARD=Device,DEV=0"
    echo -e "${GREEN}✓ USB Audio Device detected${NC}"
elif aplay -l | grep -q "Headphones"; then
    AUDIO_DEVICE="3.5mm Headphones"
    AUDIO_CONFIG="alsa/plughw:CARD=Headphones,DEV=0"
    echo -e "${GREEN}✓ 3.5mm headphone jack detected${NC}"
else
    AUDIO_DEVICE="HDMI"
    AUDIO_CONFIG="alsa/plughw:CARD=vc4hdmi0,DEV=0"
    echo -e "${YELLOW}⚠ Using HDMI audio (card 0)${NC}"
    echo -e "${YELLOW}  For 3.5mm audio on Pi 5, you need a USB audio adapter${NC}"
fi

echo -e "${BLUE}Audio output:${NC} $AUDIO_DEVICE"

# Step 8: Update control.php with detected audio device
echo ""
echo -e "${GREEN}[8/10] Configuring audio output...${NC}"
sudo sed -i "s|--audio-device=alsa/[^ ]*|--audio-device=$AUDIO_CONFIG|g" /var/www/html/music/control.php
echo -e "${GREEN}✓ Audio configured for: $AUDIO_DEVICE${NC}"

# Step 9: Test audio (optional)
echo ""
echo -e "${GREEN}[9/10] Audio test${NC}"
read -p "Would you like to test audio now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Playing test sound for 3 seconds (press Ctrl+C to stop)..."
    timeout 3 speaker-test -t wav -c 2 2>/dev/null || true
fi

# Step 10: Get IP address
echo ""
echo -e "${GREEN}[10/10] Finalizing setup...${NC}"
IP_ADDR=$(hostname -I | awk '{print $1}')

# Print success message
echo ""
echo -e "${GREEN}=================================="
echo "✓ Installation Complete!"
echo "==================================${NC}"
echo ""
echo -e "${BLUE}Your music player is ready!${NC}"
echo ""
echo -e "${YELLOW}Access your player:${NC}"
echo "  http://$IP_ADDR/music/"
echo ""
echo -e "${YELLOW}Audio Output:${NC} $AUDIO_DEVICE"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Open the URL above in a web browser"
echo "  2. Complete the first-time setup:"
echo "     - Enter a location name (e.g., 'Kitchen')"
echo "     - Enter your stream URL"
echo "     - Create a password (protects settings)"
echo "  3. Click Play and enjoy your music!"
echo ""
echo -e "${BLUE}Tips:${NC}"
echo "  • Use the ⚙️ gear icon to change settings"
echo "  • Password is only needed for settings, not daily use"
echo "  • Bookmark the URL on your phone for easy access"
echo ""

# Optional: Auto-start on boot
echo -e "${YELLOW}Optional:${NC}"
read -p "Enable auto-start on boot? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "music-stream.service" ]; then
        sudo cp music-stream.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable music-stream.service
        echo -e "${GREEN}✓ Auto-start enabled${NC}"
    else
        echo -e "${YELLOW}⚠ music-stream.service file not found. Skipping.${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Setup complete! Enjoy your music! 🎵${NC}"
echo ""
