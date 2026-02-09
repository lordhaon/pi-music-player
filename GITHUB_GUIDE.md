# 📤 How to Upload This Project to GitHub

## Method 1: Using GitHub Website (Easiest)

### Step 1: Create a New Repository

1. Go to https://github.com
2. Click the **+** icon in the top right
3. Click **New repository**
4. Fill in the details:
   - **Repository name**: `pi-music-player` (or your choice)
   - **Description**: "Web-based music streaming system for Raspberry Pi"
   - **Public** or **Private**: Your choice
   - ✅ Check "Add a README file" - then delete it after (we have our own)
   - Choose **MIT License**
5. Click **Create repository**

### Step 2: Upload Files via Web Interface

1. On your new repository page, click **uploading an existing file**
2. Drag and drop these files:
   - `install.sh`
   - `index.html`
   - `control.php`
   - `config.json`
   - `INSTALL.md`
   - `README.md`
   - `LICENSE`
   - `.gitignore`
3. Add a commit message: "Initial commit"
4. Click **Commit changes**

Done! Your project is now on GitHub!

---

## Method 2: Using Git Command Line (Recommended)

### Step 1: Install Git (if needed)

**On Windows:**
Download from https://git-scm.com/download/win

**On Mac:**
```bash
brew install git
```

**On Linux:**
```bash
sudo apt install git
```

### Step 2: Configure Git (first time only)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 3: Create Repository on GitHub

1. Go to https://github.com
2. Click **+** → **New repository**
3. Name it: `pi-music-player`
4. Description: "Web-based music streaming system for Raspberry Pi"
5. Choose **Public** or **Private**
6. **Don't** add README, .gitignore, or license (we have them)
7. Click **Create repository**

### Step 4: Upload Your Files

**On your computer, navigate to the folder with your files:**

```bash
# Navigate to your project folder
cd /path/to/your/downloaded/files

# Initialize git repository
git init

# Add all files
git add .

# Make first commit
git commit -m "Initial commit - Pi Music Player"

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR-USERNAME/pi-music-player.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Replace `YOUR-USERNAME` with your actual GitHub username!**

### Step 5: Enter Credentials

When prompted:
- **Username**: Your GitHub username
- **Password**: Your GitHub Personal Access Token (not your password!)

**Don't have a token?** 
1. Go to GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click **Generate new token (classic)**
3. Give it a name like "Pi Music Player"
4. Check the **repo** scope
5. Click **Generate token**
6. Copy the token and use it as your password

---

## Method 3: Using GitHub Desktop (Easy for Windows/Mac)

### Step 1: Download GitHub Desktop
https://desktop.github.com/

### Step 2: Sign In
Open GitHub Desktop and sign in with your GitHub account

### Step 3: Create Repository

1. Click **File** → **New repository**
2. Name: `pi-music-player`
3. Local path: Choose where your files are
4. Click **Create repository**

### Step 4: Add Files

1. Copy all your files into the repository folder
2. GitHub Desktop will show them as changes
3. Write a commit message: "Initial commit"
4. Click **Commit to main**
5. Click **Publish repository**
6. Choose Public or Private
7. Click **Publish repository**

Done!

---

## 📋 Files to Include

Make sure you have all these files:

### Required Files
- ✅ `install.sh` - Automated installer
- ✅ `index.html` - Web interface
- ✅ `control.php` - Backend controller
- ✅ `config.json` - Configuration template
- ✅ `README.md` - Main documentation
- ✅ `INSTALL.md` - Installation guide
- ✅ `LICENSE` - MIT License
- ✅ `.gitignore` - Files to ignore

### Optional Files
- `demo.html` - Demo version (optional)
- `QUICK_START.txt` - Quick reference (optional)
- `music-stream.service` - Systemd service (optional)

---

## 🎨 Customizing Your Repository

### Add a Description

On GitHub.com, go to your repository and click the ⚙️ next to **About**:
- **Description**: "Web-based music streaming system for Raspberry Pi 4 & 5"
- **Website**: (optional)
- **Topics**: `raspberry-pi`, `music-player`, `web-interface`, `streaming`, `php`, `mpv`

### Add a Nice README

The README.md I created includes:
- Feature list
- Installation instructions
- Screenshots (you can add these later)
- Troubleshooting
- License info

### Consider Adding

**Screenshots:**
1. Take screenshots of your web interface
2. Create a `screenshots/` folder
3. Upload images
4. Add them to README.md:
   ```markdown
   ![Player Interface](screenshots/player.png)
   ```

**Demo Video:**
- Record a quick demo
- Upload to YouTube
- Add link to README

---

## 🚀 After Upload

### Share Your Project

1. **Get the link**: `https://github.com/YOUR-USERNAME/pi-music-player`
2. **Share on**:
   - Reddit: r/raspberry_pi, r/selfhosted
   - Hacker News
   - Raspberry Pi Forums
   - Twitter/X

### Add Topics

On your GitHub repo page:
- Click ⚙️ next to "About"
- Add topics: `raspberry-pi`, `music`, `streaming`, `web-app`, `php`, `mpv`

### Create Releases

When you make updates:
1. Go to **Releases** → **Create a new release**
2. Tag: `v1.0.0`
3. Title: "Initial Release"
4. Describe what's new
5. Attach a ZIP of the files (optional)

---

## 📝 Updating Your Repository

When you make changes:

```bash
# Navigate to your project folder
cd /path/to/pi-music-player

# Check what changed
git status

# Add changed files
git add .

# Commit changes
git commit -m "Description of what you changed"

# Push to GitHub
git push
```

---

## 🆘 Common Issues

### "Permission denied"
You need a Personal Access Token, not your password.
Go to GitHub Settings → Developer settings → Personal access tokens

### "Repository not found"
Make sure you created the repository on GitHub first, and the URL is correct.

### "Everything up-to-date"
No changes to push. Make sure you've committed your changes first.

### Files not showing up
- Make sure they're in the correct folder
- Check `.gitignore` isn't excluding them
- Run `git add .` to add all files

---

## ✨ Make It Pretty

### Add Badges to README

The README already includes:
- License badge
- Platform badge
- PHP version badge

### Add a Star

Don't forget to star your own project! ⭐

---

## 🎉 You're Done!

Your project is now on GitHub and ready to share with the world!

Example URL: `https://github.com/YOUR-USERNAME/pi-music-player`

Happy coding! 🚀
