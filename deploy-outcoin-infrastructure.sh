#!/bin/bash

# Outcoin Infrastructure Deployment Script
# This script sets up the complete Outcoin ecosystem

set -e

echo "🚀 Outcoin Infrastructure Deployment"
echo "===================================="

# Configuration
OUTCOIN_DIR="$HOME/outcoin-infrastructure"
ELECTRUMX_DIR="$OUTCOIN_DIR/electrumx"
CORE_DIR="$OUTCOIN_DIR/outcoin-core"
WALLET_DIR="$OUTCOIN_DIR/outcoin-electrum"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check for required tools
    for tool in git python3 pip make gcc; do
        if ! command -v $tool &> /dev/null; then
            log_error "$tool is not installed. Please install it first."
            exit 1
        fi
    done
    
    log_success "All prerequisites are available"
}

# Setup directory structure
setup_directories() {
    log_info "Setting up directory structure..."
    mkdir -p "$OUTCOIN_DIR"
    cd "$OUTCOIN_DIR"
    log_success "Directory structure created"
}

# Deploy Outcoin Core
deploy_core() {
    log_info "Deploying Outcoin Core..."
    
    if [ ! -d "$CORE_DIR" ]; then
        log_info "Cloning Outcoin Core repository..."
        git clone https://github.com/outcoin-chain/outcoin-core.git "$CORE_DIR"
    fi
    
    cd "$CORE_DIR"
    
    # Build if binaries don't exist
    if [ ! -f "src/outcoind" ]; then
        log_info "Building Outcoin Core..."
        ./autogen.sh
        ./configure --disable-tests --disable-bench --without-qt
        make -j$(nproc 2>/dev/null || echo 2)
    fi
    
    # Create configuration
    mkdir -p ~/.outcoin
    cat > ~/.outcoin/outcoin.conf << EOF
# Outcoin Core Configuration
server=1
daemon=1
rpcuser=outcoin
rpcpassword=$(openssl rand -hex 32)
rpcport=19205
port=19206

# Network
addnode=seed-1.outcoin.org
addnode=seed-2.outcoin.org
addnode=seed-3.outcoin.org

# Logging
debug=1
printtoconsole=1

# RPC
rpcallowip=127.0.0.1
rpcbind=127.0.0.1
EOF
    
    log_success "Outcoin Core deployed"
}

# Deploy ElectrumX Server
deploy_electrumx() {
    log_info "Deploying ElectrumX Server..."
    
    if [ ! -d "$ELECTRUMX_DIR" ]; then
        log_info "Cloning ElectrumX repository..."
        git clone https://github.com/spesmilo/electrumx.git "$ELECTRUMX_DIR"
    fi
    
    cd "$ELECTRUMX_DIR"
    
    # Add Outcoin support if not already added
    if ! grep -q "class Outcoin" src/electrumx/lib/coins.py; then
        log_info "Adding Outcoin support to ElectrumX..."
        cat >> src/electrumx/lib/coins.py << 'EOF'

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

class OutcoinTestnet(OutcoinMixin, Coin):
    NAME = "Outcoin"
    NET = "testnet"
    RPC_PORT = 19207
    PEERS = [
        'testnet-seed-1.outcoin.org s t',
        'testnet-seed-2.outcoin.org s t',
    ]

class OutcoinRegtest(OutcoinTestnet):
    NET = "regtest"
    PEERS = []
    TX_COUNT = 1
    TX_COUNT_HEIGHT = 1
EOF
    fi
    
    # Install ElectrumX
    pip install -e .
    
    # Create ElectrumX configuration
    mkdir -p /tmp/outcoin-electrumx
    cat > electrumx-outcoin.conf << EOF
# Outcoin ElectrumX Configuration
export COIN=Outcoin
export NET=mainnet
export DB_DIRECTORY=/tmp/outcoin-electrumx
export DB_ENGINE=leveldb
export DAEMON_URL=http://outcoin:$(grep rpcpassword ~/.outcoin/outcoin.conf | cut -d'=' -f2)@127.0.0.1:19205
export HOST=127.0.0.1
export TCP_PORT=50001
export SSL_PORT=50002
export SERVICES=tcp://:50001,ssl://:50002
export LOG_LEVEL=info
EOF
    
    log_success "ElectrumX Server deployed"
}

# Deploy Outcoin Electrum Wallet
deploy_wallet() {
    log_info "Deploying Outcoin Electrum Wallet..."
    
    if [ ! -d "$WALLET_DIR" ]; then
        log_info "Cloning Outcoin Electrum repository..."
        git clone https://github.com/outcoin-chain/outcoin-electrum.git "$WALLET_DIR"
    fi
    
    cd "$WALLET_DIR"
    
    # Install wallet dependencies
    pip install -e .
    
    log_success "Outcoin Electrum Wallet deployed"
}

# Create startup scripts
create_startup_scripts() {
    log_info "Creating startup scripts..."
    
    # Outcoin Core startup script
    cat > "$OUTCOIN_DIR/start-outcoin-core.sh" << EOF
#!/bin/bash
cd "$CORE_DIR"
./src/outcoind -daemon
echo "Outcoin Core started"
EOF
    
    # ElectrumX startup script
    cat > "$OUTCOIN_DIR/start-electrumx.sh" << EOF
#!/bin/bash
cd "$ELECTRUMX_DIR"
source electrumx-outcoin.conf
./electrumx_server
EOF
    
    # Wallet startup script
    cat > "$OUTCOIN_DIR/start-wallet.sh" << EOF
#!/bin/bash
cd "$WALLET_DIR"
./run_electrum
EOF
    
    # Master startup script
    cat > "$OUTCOIN_DIR/start-all.sh" << EOF
#!/bin/bash
echo "🚀 Starting Outcoin Infrastructure..."

# Start Outcoin Core
echo "Starting Outcoin Core..."
bash "$OUTCOIN_DIR/start-outcoin-core.sh"
sleep 10

# Start ElectrumX (in background)
echo "Starting ElectrumX Server..."
bash "$OUTCOIN_DIR/start-electrumx.sh" &
sleep 5

# Start Wallet
echo "Starting Outcoin Electrum Wallet..."
bash "$OUTCOIN_DIR/start-wallet.sh"
EOF
    
    # Make scripts executable
    chmod +x "$OUTCOIN_DIR"/*.sh
    
    log_success "Startup scripts created"
}

# Create status check script
create_status_script() {
    cat > "$OUTCOIN_DIR/check-status.sh" << EOF
#!/bin/bash
echo "📊 Outcoin Infrastructure Status"
echo "==============================="

# Check Outcoin Core
if pgrep -f outcoind > /dev/null; then
    echo "✅ Outcoin Core: Running"
    cd "$CORE_DIR"
    ./src/outcoin-cli getblockcount 2>/dev/null || echo "   (Not synced yet)"
else
    echo "❌ Outcoin Core: Not running"
fi

# Check ElectrumX
if pgrep -f electrumx_server > /dev/null; then
    echo "✅ ElectrumX Server: Running"
else
    echo "❌ ElectrumX Server: Not running"
fi

# Check network connectivity
echo ""
echo "🌐 Network Status:"
ping -c 1 seed-1.outcoin.org > /dev/null 2>&1 && echo "✅ DNS Seeders: Reachable" || echo "❌ DNS Seeders: Not reachable"
EOF
    
    chmod +x "$OUTCOIN_DIR/check-status.sh"
}

# Main deployment function
main() {
    echo "This script will deploy the complete Outcoin infrastructure:"
    echo "1. Outcoin Core (blockchain node)"
    echo "2. ElectrumX Server (Electrum protocol server)"
    echo "3. Outcoin Electrum Wallet (client)"
    echo ""
    
    read -p "Continue with deployment? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Deployment cancelled"
        exit 0
    fi
    
    check_prerequisites
    setup_directories
    deploy_core
    deploy_electrumx
    deploy_wallet
    create_startup_scripts
    create_status_script
    
    log_success "🎉 Outcoin Infrastructure Deployment Complete!"
    echo ""
    echo "📁 Installation Directory: $OUTCOIN_DIR"
    echo ""
    echo "🚀 To start the infrastructure:"
    echo "   cd $OUTCOIN_DIR && ./start-all.sh"
    echo ""
    echo "📊 To check status:"
    echo "   cd $OUTCOIN_DIR && ./check-status.sh"
    echo ""
    echo "📚 For detailed setup instructions, see:"
    echo "   $OUTCOIN_DIR/INFRASTRUCTURE_SETUP.md"
}

# Run main function
main "$@" 