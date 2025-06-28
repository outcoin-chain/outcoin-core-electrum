# Outcoin Core Development Roadmap

## 🎯 **Objective**
Build Outcoin Core blockchain node with the following specifications:
- **Algorithm**: Scrypt
- **Block Time**: 60 seconds
- **Supply**: Follow Litecoin (84M coins)
- **Premine**: 0%
- **RPC Port**: 19205
- **P2P Port**: 19206
- **Ticker**: OUT
- **Merge Mining**: AuxPoW with Litecoin, Dogecoin, and Pepecoin
- **Address Format**: Custom `voutxxxx23232323HiJklam`

## 📋 **Phase 1: Foundation Setup (Week 1-2)**

### **1.1 Fork Litecoin Core**
```bash
# Clone Litecoin as base (similar parameters to Outcoin)
git clone https://github.com/litecoin-project/litecoin.git outcoin-core
cd outcoin-core
git checkout v0.21.3  # Stable version
git checkout -b outcoin-development
```

### **1.2 Basic Rebranding**
Update these files for basic Outcoin branding:

**configure.ac:**
```bash
sed -i 's/Litecoin/Outcoin/g' configure.ac
sed -i 's/litecoin/outcoin/g' configure.ac
sed -i 's/LTC/OUT/g' configure.ac
```

**src/clientversion.h:**
```cpp
#define CLIENT_VERSION_MAJOR 1
#define CLIENT_VERSION_MINOR 0
#define CLIENT_VERSION_REVISION 0
#define CLIENT_VERSION_BUILD 0

// Client name
#define CLIENT_NAME "Outcoin Core"
```

### **1.3 Update Build System**
```bash
# Update all build files
find . -name "*.am" -exec sed -i 's/litecoin/outcoin/g' {} \;
find . -name "*.ac" -exec sed -i 's/litecoin/outcoin/g' {} \;
```

## 📋 **Phase 2: Network Parameters (Week 2-3)**

### **2.1 Update chainparams.cpp**

**src/chainparams.cpp - Main Network:**
```cpp
class CMainParams : public CChainParams {
public:
    CMainParams() {
        strNetworkID = "main";
        
        // Consensus parameters
        consensus.nSubsidyHalvingInterval = 840000;  // Same as Litecoin
        consensus.BIP16Exception = uint256S("0x00000000000000000000000000000000");
        consensus.BIP34Height = 1;
        consensus.BIP34Hash = uint256S("0x00000000000000000000000000000000");
        consensus.BIP65Height = 1;
        consensus.BIP66Height = 1;
        consensus.CSVHeight = 1;
        consensus.SegwitHeight = 1;
        
        // Proof of Work parameters
        consensus.powLimit = uint256S("00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        consensus.nPowTargetTimespan = 3.5 * 24 * 60 * 60;  // 3.5 days
        consensus.nPowTargetSpacing = 60;  // 60 seconds
        consensus.fPowAllowMinDifficultyBlocks = false;
        consensus.fPowNoRetargeting = false;
        
        // AuxPoW parameters
        consensus.nAuxpowChainId = 0x0062;  // Unique Outcoin chain ID
        consensus.fStrictChainId = true;
        consensus.nAuxpowStartHeight = 1;
        consensus.fAllowLegacyBlocks = false;
        
        // Network parameters
        nDefaultPort = 19206;
        nPruneAfterHeight = 100000;
        m_assumed_blockchain_size = 1;  // GB
        m_assumed_chain_state_size = 1;  // GB
        
        // Genesis block
        const char* pszTimestamp = "Outcoin Genesis Block December 2024";
        genesis = CreateGenesisBlock(1734825600, 2084524493, 0x1e0ffff0, 1, 50 * COIN);
        consensus.hashGenesisBlock = genesis.GetHash();
        
        // Address prefixes for custom format voutxxxx23232323HiJklam
        base58Prefixes[PUBKEY_ADDRESS] = std::vector<unsigned char>(1,70);   // 'v'
        base58Prefixes[SCRIPT_ADDRESS] = std::vector<unsigned char>(1,132);  // Custom
        base58Prefixes[SECRET_KEY] = std::vector<unsigned char>(1,198);      // Private key
        base58Prefixes[EXT_PUBLIC_KEY] = {0x04, 0x88, 0xB2, 0x1E};
        base58Prefixes[EXT_SECRET_KEY] = {0x04, 0x88, 0xAD, 0xE4};
        
        bech32_hrp = "out";
        
        // Seed nodes
        vSeeds.emplace_back("seed-1.outcoin.org");
        vSeeds.emplace_back("seed-2.outcoin.org");
        vSeeds.emplace_back("seed-3.outcoin.org");
        
        // Checkpoints
        checkpointData = {
            {
                {0, uint256S("0x00000000000000000000000000000000")},  // Genesis
            }
        };
        
        chainTxData = ChainTxData{
            1734825600,  // nTime
            0,           // nTxCount
            0.0          // dTxRate
        };
    }
};
```

### **2.2 Update RPC Port**

**src/chainparamsbase.cpp:**
```cpp
class CBaseMainParams : public CBaseChainParams {
public:
    CBaseMainParams() {
        nRPCPort = 19205;  // Custom Outcoin RPC port
    }
};
```

## 📋 **Phase 3: Custom Address Format (Week 3-4)**

### **3.1 Implement Custom Address Encoding**

Create **src/outcoin_address.h:**
```cpp
#ifndef OUTCOIN_ADDRESS_H
#define OUTCOIN_ADDRESS_H

#include <string>
#include <vector>

class OutcoinAddress {
public:
    static const std::string PREFIX;
    static const size_t NETWORK_ID_SIZE = 4;
    static const size_t CHECKSUM_SIZE = 8;
    static const size_t SUFFIX_SIZE = 7;
    static const size_t TOTAL_SIZE = 23;
    
    // Encode public key hash to custom format: voutxxxx23232323HiJklam
    static std::string Encode(const std::vector<unsigned char>& hash, unsigned char version);
    
    // Decode custom format to public key hash
    static bool Decode(const std::string& addr, std::vector<unsigned char>& hash, unsigned char& version);
    
    // Validate custom address format
    static bool IsValid(const std::string& addr);
    
private:
    static std::string GenerateNetworkId(unsigned char version);
    static std::string GenerateChecksum(const std::vector<unsigned char>& hash, const std::string& network_id);
    static std::string GenerateSuffix(const std::vector<unsigned char>& hash);
};

#endif // OUTCOIN_ADDRESS_H
```

Create **src/outcoin_address.cpp:**
```cpp
#include "outcoin_address.h"
#include "hash.h"
#include "utilstrencodings.h"
#include <algorithm>

const std::string OutcoinAddress::PREFIX = "vout";

std::string OutcoinAddress::Encode(const std::vector<unsigned char>& hash, unsigned char version) {
    if (hash.size() != 20) return "";  // Invalid hash size
    
    std::string result = PREFIX;
    
    // Generate network identifier (4 chars)
    result += GenerateNetworkId(version);
    
    // Generate checksum (8 chars)
    std::string network_id = result.substr(4, 4);
    result += GenerateChecksum(hash, network_id);
    
    // Generate suffix (7 chars)
    result += GenerateSuffix(hash);
    
    return result;
}

bool OutcoinAddress::Decode(const std::string& addr, std::vector<unsigned char>& hash, unsigned char& version) {
    if (!IsValid(addr)) return false;
    
    // Extract components
    std::string prefix = addr.substr(0, 4);
    std::string network_id = addr.substr(4, 4);
    std::string checksum = addr.substr(8, 8);
    std::string suffix = addr.substr(16, 7);
    
    // Reverse engineering from address format
    // This is a simplified implementation - full implementation would
    // reverse the encoding process
    
    hash.resize(20);
    version = 70;  // Default to P2PKH
    
    return true;
}

bool OutcoinAddress::IsValid(const std::string& addr) {
    if (addr.length() != TOTAL_SIZE) return false;
    if (addr.substr(0, 4) != PREFIX) return false;
    
    // Additional validation logic here
    return true;
}

std::string OutcoinAddress::GenerateNetworkId(unsigned char version) {
    // Generate 4-character network identifier based on version
    char network_id[5];
    snprintf(network_id, 5, "%04x", version);
    return std::string(network_id);
}

std::string OutcoinAddress::GenerateChecksum(const std::vector<unsigned char>& hash, const std::string& network_id) {
    // Generate 8-character checksum
    std::vector<unsigned char> data;
    data.insert(data.end(), hash.begin(), hash.end());
    data.insert(data.end(), network_id.begin(), network_id.end());
    
    uint256 hash_result = Hash(data.begin(), data.end());
    return HexStr(hash_result).substr(0, 8);
}

std::string OutcoinAddress::GenerateSuffix(const std::vector<unsigned char>& hash) {
    // Generate 7-character suffix from hash
    std::string hex = HexStr(hash);
    std::string suffix;
    
    // Convert hex to alphanumeric pattern
    for (size_t i = 0; i < 7 && i < hex.length(); ++i) {
        char c = hex[i];
        if (c >= '0' && c <= '9') {
            suffix += (char)('A' + (c - '0'));
        } else {
            suffix += (char)('a' + (c - 'a'));
        }
    }
    
    return suffix;
}
```

### **3.2 Integrate Custom Address Format**

Update **src/base58.cpp** to use custom format:
```cpp
#include "outcoin_address.h"

std::string EncodeBase58Check(const std::vector<unsigned char>& vchIn) {
    // Use custom Outcoin address format instead of standard Base58
    if (vchIn.size() == 21) {  // P2PKH or P2SH
        unsigned char version = vchIn[0];
        std::vector<unsigned char> hash(vchIn.begin() + 1, vchIn.end());
        return OutcoinAddress::Encode(hash, version);
    }
    
    // Fallback to standard Base58 for other data
    return EncodeBase58CheckStandard(vchIn);
}
```

## 📋 **Phase 4: AuxPoW Integration (Week 4-5)**

### **4.1 Enable AuxPoW Support**

Update **src/pow.cpp:**
```cpp
#include "auxpow.h"

bool CheckProofOfWork(uint256 hash, unsigned int nBits, const Consensus::Params& params, bool fCheckAuxPow) {
    bool fNegative;
    bool fOverflow;
    arith_uint256 bnTarget;
    
    bnTarget.SetCompact(nBits, &fNegative, &fOverflow);
    
    // Check range
    if (fNegative || bnTarget == 0 || fOverflow || bnTarget > UintToArith256(params.powLimit))
        return false;
    
    // Check proof of work matches claimed amount
    if (UintToArith256(hash) > bnTarget)
        return false;
    
    return true;
}

// AuxPoW validation
bool CheckAuxPow(const CAuxPow& auxpow, const uint256& hashAuxBlock, int nChainId, const Consensus::Params& params) {
    // Validate auxiliary proof of work
    if (auxpow.nChainId != nChainId)
        return false;
    
    if (!CheckProofOfWork(auxpow.parentBlock.GetHash(), auxpow.parentBlock.nBits, params, false))
        return false;
    
    return true;
}
```

### **4.2 Add AuxPoW Block Header**

Update **src/primitives/block.h:**
```cpp
#include "auxpow.h"

class CBlockHeader {
public:
    // Standard block header fields
    int32_t nVersion;
    uint256 hashPrevBlock;
    uint256 hashMerkleRoot;
    uint32_t nTime;
    uint32_t nBits;
    uint32_t nNonce;
    
    // AuxPoW support
    std::shared_ptr<CAuxPow> auxpow;
    
    bool IsAuxpow() const {
        return nVersion & VERSION_AUXPOW;
    }
    
    void SetAuxpow(std::shared_ptr<CAuxPow> auxpow_in) {
        auxpow = auxpow_in;
        if (auxpow)
            nVersion |= VERSION_AUXPOW;
        else
            nVersion &= ~VERSION_AUXPOW;
    }
};
```

## 📋 **Phase 5: Testing & Integration (Week 5-6)**

### **5.1 Create Genesis Block**
```bash
# Generate genesis block
cd src
./outcoind -printtogenesis
# This will output the genesis block hash and merkle root
```

### **5.2 Local Testing**
```bash
# Build Outcoin Core
make clean
./autogen.sh
./configure --disable-tests --disable-bench
make -j$(nproc)

# Test in regtest mode
./src/outcoind -regtest -daemon
./src/outcoin-cli -regtest generate 101
./src/outcoin-cli -regtest getblockchaininfo
```

### **5.3 Integration with ElectrumX**
```bash
# Update ElectrumX configuration
export COIN=Outcoin
export NET=regtest
export DAEMON_URL=http://outcoin:password@127.0.0.1:18443
./electrumx_server
```

## 📋 **Phase 6: Production Deployment (Week 6-7)**

### **6.1 Mainnet Launch**
```bash
# Update genesis hash in chainparams.cpp
# Deploy to production servers
# Start mainnet nodes
./src/outcoind -daemon
```

### **6.2 DNS Seeders**
Set up DNS seeders:
- seed-1.outcoin.org
- seed-2.outcoin.org
- seed-3.outcoin.org

### **6.3 ElectrumX Production**
```bash
# Deploy public ElectrumX servers
export COIN=Outcoin
export NET=mainnet
export DAEMON_URL=http://outcoin:password@127.0.0.1:19205
./electrumx_server
```

## 🔧 **Development Tools & Resources**

### **Required Skills:**
- C++ programming
- Bitcoin/Litecoin core development
- Cryptography knowledge
- AuxPoW/merge mining experience

### **Testing Framework:**
```bash
# Unit tests
make check

# Functional tests
test/functional/test_runner.py

# Performance tests
test/util/bitcoin-util-test.py
```

### **Documentation:**
- Bitcoin Developer Documentation
- Litecoin Technical Documentation
- AuxPoW Specification
- Electrum Protocol Documentation

## 🎯 **Success Criteria**

### **Phase 1 Complete:**
- ✅ Successful Litecoin fork
- ✅ Basic rebranding completed
- ✅ Build system updated

### **Phase 2 Complete:**
- ✅ Network parameters updated
- ✅ Custom ports configured
- ✅ Genesis block created

### **Phase 3 Complete:**
- ✅ Custom address format implemented
- ✅ Address validation working
- ✅ Base58 encoding updated

### **Phase 4 Complete:**
- ✅ AuxPoW support enabled
- ✅ Merge mining functional
- ✅ Parent chain validation

### **Phase 5 Complete:**
- ✅ Local testing successful
- ✅ ElectrumX integration working
- ✅ Wallet connectivity confirmed

### **Phase 6 Complete:**
- ✅ Mainnet launched
- ✅ Public infrastructure deployed
- ✅ Network operational

## 📊 **Timeline Summary**

- **Week 1-2**: Foundation & Basic Setup
- **Week 3**: Network Parameters
- **Week 4**: Custom Address Format
- **Week 5**: AuxPoW Integration
- **Week 6**: Testing & Integration
- **Week 7**: Production Deployment

**Total Timeline**: 6-7 weeks for complete Outcoin Core development

---

**Next Step**: Begin Phase 1 - Fork Litecoin and set up development environment. 