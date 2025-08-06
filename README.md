# BHTikTok++

A powerful iOS tweak that enhances your TikTok experience with additional features like ad blocking, video downloads, and UI customization.

[![Documentation](https://img.shields.io/badge/docs-comprehensive-blue.svg)](docs/)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![Language](https://img.shields.io/badge/language-Objective--C-orange.svg)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)
[![Framework](https://img.shields.io/badge/framework-Theos-red.svg)](https://theos.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## ✨ Key Features

- **🚫 Ad-Free Experience** - Remove all advertisements
- **📥 Download Content** - Save videos, photos, and music
- **🎨 UI Customization** - Hide elements and customize interface
- **🔒 Privacy Controls** - App lock and jailbreak detection bypass
- **🌍 Region Spoofing** - Access content from different countries
- **⚡ Enhanced Playback** - Speed controls and auto-play options

## 🚀 Installation

### Requirements
- Jailbroken iOS device (iOS 15.4+) + Rootless
- MobileSubstrate installed
- [FLEXing](https://alias20.gitlab.io/apt/) and [libflex](https://alias20.gitlab.io/apt/) from the provided repo

### Manual Installation
1. Download the latest `.deb` file from [Releases](../../releases)
2. Install with your Package Manager like Sileo or what ever your setup is
3. Restart TikTok

## ⚙️ Configuration

1. Open TikTok → Profile → Settings
2. Find "BHTikTok++ settings" in the Account section
3. Configure your preferred features

# Building from source
```bash
# Clone the project
git clone https://github.com/kunhir0/BHTikTokPlusPlusPlus.git

cd BHTikTokPlusPlusPlus

# Install dependencies and build
make clean && make

# Configure your test device
export THEOS_DEVICE_IP=YOUR_DEVICE_IP
export THEOS_DEVICE_USER=root
```
Now heres where you choose to make a .deb package or have it auto-install on your device via theos

```bash
# Build and install the tweak to your device
make install FINALPACKAGE=1

# Alternatively, create a deb package first
make package FINALPACKAGE=1
```
restart your tiktok then check your settings for bhtiktok... Profit~

## 🤝 Contributing

We welcome contributions! Please check our [Contributing Guide](CONTRIBUTING.md) for details including building the source.

## 📚 Documentation

- **[Full Feature List](docs/)** - Complete documentation of all features
- **[API Documentation](docs/core/)** - Technical implementation details

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## ⚠️ Disclaimer

This tweak is for educational purposes. Users are responsible for complying with TikTok's Terms of Service.

---

**For detailed documentation and advanced features, visit the [`docs/`](docs/) directory.**
