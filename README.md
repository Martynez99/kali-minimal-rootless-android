# Kali Linux Minimal - Rootless Android

A lightweight, rootless Kali Linux installation script for Android devices running Termux. This project provides a minimal Kali Linux environment without requiring root access.

## 🎯 Features

- **Rootless Installation**: No root/superuser access required
- **Minimal Footprint**: Lightweight Kali Linux rootfs
- **Termux Compatible**: Works seamlessly with Termux
- **PRoot Based**: Uses PRoot for filesystem isolation
- **Easy Setup**: One-command installation
- **Multi-Architecture Support**: ARM64, ARM32, x86_64
- **Color-coded Output**: Clear installation feedback

## 📋 Requirements

### Device Requirements
- Android 5.0+ (Termux compatible device)
- Minimum 2GB free storage space
- 1GB+ RAM recommended
- Stable internet connection for downloading rootfs

### Termux Requirements
- Termux app installed from F-Droid or Google Play
- Bash shell
- The following packages will be installed automatically:
  - `proot` - For rootless container environment
  - `tar` - For extracting rootfs
  - `curl` - For downloading files

## 🚀 Quick Start

### 1. Install Termux
Download and install [Termux](https://termux.com/) from F-Droid or Google Play Store.

### 2. Update Termux
```bash
pkg update && pkg upgrade -y
```

### 3. Clone this Repository
```bash
git clone https://github.com/Martynez99/kali-minimal-rootless-android.git
cd kali-minimal-rootless-android
```

### 4. Run Installation Script
```bash
bash install-kali.sh
```

The script will:
- ✅ Check your device architecture
- ✅ Install required dependencies (proot, tar, curl)
- ✅ Download Kali Linux rootfs
- ✅ Extract the rootfs to your home directory
- ✅ Create a launch script

### 5. Launch Kali Linux
```bash
bash ~/kali-minimal/start-kali.sh
```

## 📁 Installation Structure

```
~/kali-minimal/
├── kali-rootfs.tar.xz    # Downloaded rootfs archive
├── rootfs/               # Extracted Kali Linux filesystem
├── start-kali.sh         # Launch script
└── install-kali.sh       # This installation script
```

## 🔧 Usage

### Starting Kali Linux
```bash
bash ~/kali-minimal/start-kali.sh
```

### First Time Setup (inside Kali)
Once inside the Kali environment:

```bash
# Update package lists
apt update

# Install minimal tools
apt install -y kali-tools-information-gathering

# Verify installation
kali-linux
```

### Using Kali Tools
Common Kali penetration testing tools:

```bash
# Network scanning
nmap -sV target.com

# Web exploitation
sqlmap -u "http://target.com/page?id=1" --dbs

# Password testing
hashcat -m 0 hashes.txt wordlist.txt

# Information gathering
recon-ng
```

## ⚙️ Configuration

### Changing Installation Directory
Edit the `install-kali.sh` script and modify:
```bash
KALI_DIR="${HOME}/kali-minimal"
```

### Customizing Rootfs URL
To use a different Kali version or mirror:
```bash
ROOTFS_URL="https://your-mirror.com/path/to/rootfs.tar.xz"
```

### Adding More Tools
Inside Kali Linux:
```bash
apt install -y kali-tools-wireless  # Wireless tools
apt install -y kali-tools-web       # Web testing tools
apt install -y kali-tools-reverse-engineering  # Reverse engineering
```

## 🌐 Supported Architectures

| Architecture | Support | Notes |
|---|---|---|
| ARM64 (aarch64) | ✅ Full | Recommended for modern devices |
| ARM32 (armv7l) | ⚠️ Limited | Older devices only |
| x86_64 | ✅ Full | For Chromebooks or x86 Android |

## 🛠️ Troubleshooting

### Installation Hangs During Download
- Check your internet connection
- Try restarting Termux
- Use a different network (WiFi vs Mobile data)

### "proot: command not found"
```bash
pkg install proot
```

### "Permission denied" error
Ensure the script has execute permissions:
```bash
chmod +x install-kali.sh
bash install-kali.sh
```

### Low Storage Space
Free up at least 2GB:
```bash
# Check available space
df -h

# Clean Termux cache
pkg clean
```

### Slow Performance
- Close other apps
- Use a device with more RAM
- Consider using only essential tools

## 📚 Resources

- [Kali Linux Official](https://www.kali.org/)
- [Termux Official](https://termux.com/)
- [PRoot Documentation](https://proot-me.github.io/)
- [Kali Tools Index](https://tools.kali.org/)

## 📝 License

This project is provided as-is for educational purposes. Ensure you have proper authorization before performing any security testing.

## ⚠️ Legal Notice

**Educational Use Only**: This tool is designed for:
- Learning cybersecurity concepts
- Authorized penetration testing
- Network security research
- Educational demonstrations

**Do NOT use** for:
- Unauthorized access to systems
- Illegal activities
- Malicious purposes
- Accessing systems without permission

Always obtain written permission before conducting security assessments.

## 🤝 Contributing

Found a bug or want to improve? Feel free to:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## 📧 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check existing issues for solutions
- Provide detailed error messages and device info

## 🔄 Updates

To update your Kali installation:

```bash
cd ~/kali-minimal
# Remove old rootfs
rm kali-rootfs.tar.xz
# Re-run installation script
bash install-kali.sh
```

---

**Happy Hacking! 🎯**

*Remember: With great power comes great responsibility. Use this tool ethically and legally.*
