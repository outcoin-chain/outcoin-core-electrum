# Outcoin Electrum Wallet

[![Build Status](https://github.com/outcoin-chain/outcoin-core-electrum/workflows/Build/badge.svg)](https://github.com/outcoin-chain/outcoin-core-electrum/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)

**Outcoin Electrum** is a lightweight Outcoin wallet based on the Electrum wallet framework, specifically designed for the Outcoin blockchain network.

## 🚀 Features

- **Lightweight**: No blockchain download required - connects to Outcoin servers
- **Secure**: Deterministic wallet generation with BIP39 seed phrases
- **Multi-platform**: Available for Windows, macOS, Linux, and Android
- **Hardware Wallet Support**: Compatible with Ledger, Trezor, and other hardware wallets
- **Multi-signature**: Support for multi-signature wallets
- **Lightning Network**: Built-in Lightning Network support (when available)
- **Cold Storage**: Offline transaction signing capabilities

## 📋 Requirements

- **Python**: 3.10 or higher
- **Operating System**: Windows 10+, macOS 10.14+, Linux (Ubuntu 18.04+), Android 8.0+
- **Memory**: Minimum 512MB RAM
- **Storage**: 100MB free space

## 🛠️ Installation

### Quick Start (Recommended)

Download the latest release for your platform from the [Releases page](https://github.com/outcoin-chain/outcoin-core-electrum/releases).

### From Source

#### Prerequisites

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install python3 python3-pip python3-pyqt6 libsecp256k1-dev
```

**macOS:**
```bash
brew install python3 qt6 libsecp256k1
```

**Windows:**
- Install Python 3.10+ from [python.org](https://www.python.org/downloads/)
- Install Qt6 from [qt.io](https://www.qt.io/download)

#### Installation Steps

1. **Clone the repository:**
```bash
git clone https://github.com/outcoin-chain/outcoin-core-electrum.git
cd outcoin-core-electrum
```

2. **Install dependencies:**
```bash
python3 -m pip install --user -e .
```

3. **Run the wallet:**
```bash
./run_electrum
```

### Docker Installation

```bash
docker pull outcoin-chain/outcoin-core-electrum:latest
docker run -it --rm outcoin-chain/outcoin-core-electrum:latest
```

## 🔧 Configuration

### Network Settings

Outcoin Electrum is pre-configured for the Outcoin network:

- **Mainnet**: 
  - RPC Port: 19205
  - P2P Port: 19206
  - DNS Seeders: Configured automatically
- **Testnet**: 
  - RPC Port: 19207
  - P2P Port: 19208
  - DNS Seeders: Configured automatically

### Custom Server Configuration

You can configure custom servers in the wallet settings or by editing the server configuration files in `electrum/chains/`.

## 🏗️ Building from Source

### Linux Build

```bash
# Install build dependencies
sudo apt-get install python3-dev python3-pip python3-setuptools

# Build the application
python3 setup.py build

# Create distribution
python3 setup.py sdist
```

### Windows Build

```bash
# Install Visual Studio Build Tools
# Install Python 3.10+

# Build with PyInstaller
pip install pyinstaller
pyinstaller --onefile run_electrum
```

### macOS Build

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Build the application
python3 setup.py build

# Create .app bundle
python3 contrib/osx/build_osx.py
```

## 🧪 Testing

Run the test suite:

```bash
# Install test dependencies
pip install pytest pytest-cov

# Run all tests
pytest tests/ -v

# Run specific test file
pytest tests/test_bitcoin.py -v

# Run with coverage
pytest tests/ --cov=electrum
```

## 📦 Creating Binaries

### Linux AppImage
```bash
cd contrib/build-linux/appimage
./build.sh
```

### Windows Executable
```bash
cd contrib/build-wine
./build-electrum-git.sh
```

### macOS App Bundle
```bash
cd contrib/osx
./build_osx.sh
```

### Android APK
```bash
cd contrib/android
./build.sh
```

## 🔒 Security

### Verifying Downloads

Always verify the integrity of downloaded files:

```bash
# Download the release and signature
wget https://github.com/outcoin-chain/outcoin-core-electrum/releases/download/v1.0.0/outcoin-electrum-1.0.0.tar.gz
wget https://github.com/outcoin-chain/outcoin-core-electrum/releases/download/v1.0.0/outcoin-electrum-1.0.0.tar.gz.asc

# Verify signature
gpg --verify outcoin-electrum-1.0.0.tar.gz.asc
```

### Security Best Practices

1. **Backup your seed phrase** in a secure location
2. **Use hardware wallets** for large amounts
3. **Keep your software updated** to the latest version
4. **Verify download signatures** before installation
5. **Use strong passwords** for wallet encryption

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Add tests for new functionality
5. Run the test suite: `pytest tests/`
6. Commit your changes: `git commit -am 'Add feature'`
7. Push to the branch: `git push origin feature-name`
8. Submit a Pull Request

### Code Style

- Follow PEP 8 for Python code
- Use meaningful variable and function names
- Add docstrings for all public functions
- Write unit tests for new features

## 📞 Support

### Getting Help

- **Documentation**: [Wiki](https://github.com/outcoin-chain/outcoin-core-electrum/wiki)
- **Issues**: [GitHub Issues](https://github.com/outcoin-chain/outcoin-core-electrum/issues)
- **Discussions**: [GitHub Discussions](https://github.com/outcoin-chain/outcoin-core-electrum/discussions)
- **Discord**: [Outcoin Discord](https://discord.gg/outcoin-chain)

### Reporting Bugs

When reporting bugs, please include:

1. Operating system and version
2. Outcoin Electrum version
3. Steps to reproduce the issue
4. Error messages or logs
5. Screenshots (if applicable)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Electrum Team**: For the original Electrum wallet framework
- **Bitcoin Core**: For cryptographic libraries and standards
- **Outcoin Community**: For support and contributions

## 📊 Network Information

- **Algorithm**: Scrypt
- **Block Time**: 60 seconds
- **Total Supply**: 84,000,000 OUT
- **Premine**: 0%
- **Ticker**: OUT
- **Website**: https://outcoin.org
- **Explorer**: https://explorer.outcoin.org
- **GitHub**: https://github.com/outcoin-chain

---

**⚠️ Disclaimer**: This software is provided "as is" without warranty. Always verify your transactions and keep your private keys secure.
