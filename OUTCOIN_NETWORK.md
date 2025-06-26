# Outcoin Network Specifications

## Core Network Parameters

- **Algorithm**: Scrypt
- **Block Time**: 60 seconds
- **Supply**: 84,000,000 OUT (following Litecoin)
- **Premine**: 0%
- **RPC Port**: 19205
- **P2P Port**: 19206
- **Ticker**: OUT

## DNS Seeders

### Mainnet
- seed-1.outcoin.org
- seed-2.outcoin.org
- seed-3.outcoin.org

### Testnet
- testnet-seed-1.outcoin.org
- testnet-seed-2.outcoin.org
- testnet-seed-3.outcoin.org

## Network Configuration

### Mainnet
- **SegWit HRP**: "out"
- **Default Ports**: {'t': '19205', 's': '19206'}
- **BIP44 Coin Type**: 0

### Testnet
- **SegWit HRP**: "tout"
- **Default Ports**: {'t': '19207', 's': '19208'}
- **BIP44 Coin Type**: 1

## Resources

- **Website**: https://outcoin.org
- **Explorer**: https://explorer.outcoin.org
- **GitHub**: https://github.com/outcoin-chain/outcoin-core/outcoin-core.git
- **Social**: 
  - https://x/outcoin-chain/
  - https://discord.com/outcoin-chain

## Technical Details

Outcoin is a fork of Electrum wallet, adapted to work with the Outcoin blockchain. The wallet maintains all the original Electrum functionality while being configured for the Outcoin network parameters.

### Key Changes from Bitcoin
- Uses Scrypt algorithm instead of SHA256
- 60-second block time (vs 10 minutes for Bitcoin)
- 84 million total supply (vs 21 million for Bitcoin)
- Custom network ports and DNS seeders
- Outcoin-specific address prefixes and SegWit HRP

### Compatibility
The wallet maintains full compatibility with:
- Hardware wallets (Trezor, Ledger, Coldcard, etc.)
- Lightning Network
- Multi-signature wallets
- All Electrum plugins and features 