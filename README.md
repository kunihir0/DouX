# DouX

A powerful iOS tweak that enhances your TikTok experience with additional features like ad blocking, video downloads, and UI customization.

[![Documentation](https://img.shields.io/badge/docs-comprehensive-blue.svg)](docs/)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![Language](https://img.shields.io/badge/language-Objective--C-orange.svg)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)
[![Framework](https://img.shields.io/badge/framework-Theos-red.svg)](https://theos.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Key Features

- Ad-Free Experience: Remove all advertisements
- Download Content: Save videos, photos, and music
- Media Vault: Securely store your favorite photos and videos
- UI Customization: Hide elements and customize interface
- Privacy Controls: App lock and jailbreak detection bypass
- Region Spoofing: Access content from different countries
- Enhanced Playback: Speed controls and auto-play options

## Installation

### Requirements
- Jailbroken iOS device (iOS 15.4+) + Rootless
- MobileSubstrate installed
- [libflex](https://alias20.gitlab.io/apt/) from the provided repo

### Manual Installation
1. Download the latest `.deb` file from [Releases](../../releases)
2. Install with your Package Manager like Sileo or what ever your setup is
3. Restart TikTok

### Building from Source

For this method, you will need a development environment with Theos set up. Follow these comprehensive setup steps:

#### 1. Prerequisites Setup

```bash
# Install full Xcode from App Store (required - Command Line Tools alone are insufficient)
# After installation, accept the license:
sudo xcodebuild -license accept

# Verify Xcode installation
xcode-select --print-path
```

#### 2. Theos Installation

```bash
# Install Theos using the official installation script
bash -c "$(curl -fsSL https://raw.githubusercontent.com/theos/theos/master/bin/install-theos)"

# The script will automatically:
# - Install Theos to /opt/theos
# - Set up environment variables
# - Configure your shell profile

# Verify installation
echo $THEOS
# Should output: /opt/theos

# Restart your terminal or source your shell profile
source ~/.zshrc  # or ~/.bash_profile for bash users
```

#### 3. Project Setup

```bash
# Clone the repository
git clone https://github.com/kunihir0/BHTikTokPlusPlusPlus.git
cd BHTikTokPlusPlusPlus

# Add upstream remote (if working with a fork)
git remote add upstream https://github.com/kunihir0/BHTikTokPlusPlusPlus.git

# Install dependencies and build
make clean && make
```

#### 4. Device Configuration

```bash
# Configure your test device
export THEOS_DEVICE_IP=YOUR_DEVICE_IP
export THEOS_DEVICE_USER=root

# Test connection
ssh root@$THEOS_DEVICE_IP "echo 'Connection successful'"
```

#### 5. Build and Install

```bash
# Build and install the tweak to your device
make install

# Alternatively, create a package first
make package

# Then install manually
make install
```

#### 6. Building for different architectures

To build for a specific architecture, you can use the `THEOS_PACKAGE_SCHEME` and `ARCHS` environment variables. For example, to build for rootless, you would use the following command:

```bash
make package THEOS_PACKAGE_SCHEME=rootless ARCHS=arm64
```

To build for roothide, you would use the following command:

```bash
make package THEOS_PACKAGE_SCHEME=roothide ARCHS=arm64e
```

#### 6. Final Steps

1. **Restart the TikTok application** after installation
2. **Verify installation** by checking TikTok settings for BHTikTok++ options

## Configuration

1. Open TikTok → Profile → Settings
2. Find "DouX settings" in the Account section
3. Configure your preferred features

## Contributing

We welcome contributions! Please check our [Contributing Guide](CONTRIBUTING.md) for details including building the source.

## Documentation

- **[Full Feature List](docs/)** - Complete documentation of all features
- **[API Documentation](docs/core/)** - Technical implementation details

## License

MIT License - see [LICENSE](LICENSE) for details.

## Disclaimer

This tweak is for educational purposes. Users are responsible for complying with TikTok's Terms of Service.

---

**For detailed documentation and advanced features, visit the [`docs/`](docs/) directory.**