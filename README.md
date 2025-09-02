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
- JGProgress from our [repo](https://kunihir0.github.io/WattMaster/) 

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

### Building the Tweak with Embedded Libraries

By default, this project links against the `JGProgressHUD` library, which is expected to be installed on your device separately. If you prefer to build a version of the tweak with this library embedded directly into the `.deb` package, you can do so by applying a patch before building.

This method is useful for creating a more portable package that doesn't rely on external dependencies.

**Steps:**

1.  **Apply the patch:**
    ```bash
    git apply scripts/compile_jgprogresshud.patch
    ```

2.  **Build the tweak:**
    ```bash
    make package
    ```

3.  **Revert the patch (optional but recommended):**
    ```bash
    git apply -R scripts/compile_jgprogresshud.patch
    ```

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

## Creating a Patched IPA

This project includes a Python script that automates the process of patching a decrypted IPA with this tweak. This is useful for sideloading the application on non-jailbroken devices.

### Prerequisites

*   Python 3
*   A decrypted IPA file of TikTok.

### Usage

The `ipa_packager.py` script is located in the `scripts/` directory. It can be used in two ways:

**1. Build the tweak locally and patch the IPA:**

This is the recommended method. The script will first compile the tweak and then patch the IPA with the newly created `.deb` file.

```bash
python3 scripts/ipa_packager.py --ipa <URL or local path to decrypted IPA>
```

**2. Use a pre-built tweak to patch the IPA:**

If you have a pre-built `.deb` file of the tweak, you can provide a URL to it.

```bash
python3 scripts/ipa_packager.py --ipa <URL or local path to decrypted IPA> --tweak_url <URL to .deb file>
```

MIT License - see [LICENSE](LICENSE) for details.

## Disclaimer

This tweak is for educational purposes. Users are responsible for complying with TikTok's Terms of Service.

---

**For detailed documentation and advanced features, visit the [`docs/`](docs/) directory.**
