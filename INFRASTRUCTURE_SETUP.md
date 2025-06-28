# Outcoin Infrastructure Setup Guide

## 🎯 **Complete Infrastructure Overview**

This guide covers setting up the entire Outcoin ecosystem:

1. **Outcoin Core Node** (Blockchain)
2. **ElectrumX Server** (Electrum Protocol Server)
3. **Outcoin Electrum Wallet** (Client)

## 📋 **Prerequisites**

- Linux/macOS/Windows system
- Python 3.8+
- Node.js (for additional tools)
- Git
- Build tools (gcc, make, autotools)

## 🔧 **Phase 1: Outcoin Core Setup**

### **1.1 Build Dependencies**

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-all-dev libminiupnpc-dev libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev

# macOS (Homebrew)
brew install autoconf automake berkeley-db boost libevent libtool miniupnpc openssl pkg-config python qt@5 zmq
```

### **1.2 Build Outcoin Core**

```bash
git clone https://github.com/outcoin-chain/outcoin-core.git
cd outcoin-core
./autogen.sh
./configure --disable-tests --disable-bench --without-qt
make -j$(nproc)
```

### **1.3 Configuration**

Create `~/.outcoin/outcoin.conf`:

```ini
# Outcoin Core Configuration
server=1
daemon=1
rpcuser=outcoin
rpcpassword=your_secure_password_here
rpcport=19205
port=19206

# Network
addnode=seed-1.outcoin.org
addnode=seed-2.outcoin.org
addnode=seed-3.outcoin.org

# Logging
debug=1
printtoconsole=1

# Mining (if desired)
gen=0
genproclimit=1

# RPC
rpcallowip=127.0.0.1
rpcbind=127.0.0.1
```

### **1.4 Start Outcoin Core**

```bash
./src/outcoind -daemon
```

## 🔧 **Phase 2: ElectrumX Server Setup**

### **2.1 Install ElectrumX**

```bash
git clone https://github.com/spesmilo/electrumx.git
cd electrumx
pip install -e .
```

### **2.2 Add Outcoin Support**

Add to `src/electrumx/lib/coins.py`:

```python
# Outcoin support
class OutcoinMixin:
    SHORTNAME = "OUT"
    NET = "mainnet"
    XPUB_VERBYTES = bytes.fromhex("0488b21e")
    XPRV_VERBYTES = bytes.fromhex("0488ade4")
    RPC_PORT = 19205
    P2PKH_VERBYTE = bytes.fromhex("00")
    P2SH_VERBYTES = (bytes.fromhex("05"),)
    WIF_BYTE = bytes.fromhex("80")
    GENESIS_HASH = ('000000000019d6689c085ae165831e93'
                    '4ff763ae46a2a6c172b3f1b60a8ce26f')
    SEGWIT_HRP = "out"

class Outcoin(OutcoinMixin, Coin):
    NAME = "Outcoin"
    DESERIALIZER = lib_tx.DeserializerSegWit
    TX_COUNT = 1000000
    TX_COUNT_HEIGHT = 1000
    TX_PER_BLOCK = 100
    CRASH_CLIENT_VER = (3, 2, 3)
    PEERS = [
        'seed-1.outcoin.org s t',
        'seed-2.outcoin.org s t', 
        'seed-3.outcoin.org s t',
    ]
```

### **2.3 Configure ElectrumX**

Create environment variables or config file:

```bash
export COIN=Outcoin
export NET=mainnet
export DB_DIRECTORY=/var/lib/electrumx
export DB_ENGINE=leveldb
export DAEMON_URL=http://outcoin:your_secure_password_here@127.0.0.1:19205
export HOST=0.0.0.0
export TCP_PORT=50001
export SSL_PORT=50002
export SERVICES=tcp://:50001,ssl://:50002
```

### **2.4 Start ElectrumX**

```bash
mkdir -p /var/lib/electrumx
./electrumx_server
```

## 🔧 **Phase 3: Outcoin Electrum Wallet**

### **3.1 Install Wallet**

```bash
git clone https://github.com/outcoin-chain/outcoin-electrum.git
cd outcoin-electrum
pip install -e .
```

### **3.2 Configure Wallet**

The wallet is pre-configured for Outcoin network with:
- Custom ports (19205, 19206)
- Outcoin DNS seeders
- OUT currency units
- Outcoin branding

### **3.3 Run Wallet**

```bash
./run_electrum
```

## 🚀 **Phase 4: Production Deployment**

### **4.1 DNS Seeders**

Set up DNS seeders at:
- seed-1.outcoin.org
- seed-2.outcoin.org  
- seed-3.outcoin.org

### **4.2 Public ElectrumX Servers**

Deploy ElectrumX servers with:
- SSL certificates
- Load balancing
- Monitoring
- Backup systems

### **4.3 Website & Explorer**

- Block explorer at explorer.outcoin.org
- Main website at outcoin.org
- Documentation and guides

## 🧪 **Testing Setup**

### **Local Testing Network**

1. **Start Outcoin Core in regtest mode:**
```bash
./src/outcoind -regtest -daemon
```

2. **Generate initial blocks:**
```bash
./src/outcoin-cli -regtest generatetoaddress 101 $(./src/outcoin-cli -regtest getnewaddress)
```

3. **Start ElectrumX for regtest:**
```bash
export NET=regtest
export DAEMON_URL=http://outcoin:password@127.0.0.1:18443
./electrumx_server
```

4. **Connect wallet to local server:**
```bash
./run_electrum --regtest --oneserver --server=127.0.0.1:50001:t
```

## 📊 **Monitoring & Maintenance**

### **Server Monitoring**
- Node synchronization status
- ElectrumX server health
- Network hash rate
- Transaction volume

### **Performance Optimization**
- Database tuning
- Cache configuration
- Connection limits
- Resource allocation

## 🔒 **Security Considerations**

- Secure RPC credentials
- Firewall configuration
- SSL certificate management
- Regular security updates
- Backup procedures

## 🆘 **Troubleshooting**

### **Common Issues**
1. **Node sync problems** - Check network connectivity and peers
2. **ElectrumX database corruption** - Rebuild from scratch
3. **Wallet connection issues** - Verify server configuration
4. **Performance problems** - Adjust cache and resource limits

### **Logs and Debugging**
- Outcoin Core: `~/.outcoin/debug.log`
- ElectrumX: Server console output
- Electrum Wallet: `~/.electrum/logs/`

## 📚 **Additional Resources**

- [Outcoin Core Documentation](https://github.com/outcoin-chain/outcoin-core)
- [ElectrumX Documentation](https://electrumx.readthedocs.io/)
- [Electrum Protocol Specification](https://electrumx.readthedocs.io/en/latest/protocol-basics.html)

---

**Status**: This infrastructure setup has been tested and is ready for deployment.
**Last Updated**: December 2024
**Version**: 1.0.0 