class OutcoinMixin:
    SHORTNAME = "OUT"
    NET = "mainnet"
    XPUB_VERBYTES = bytes.fromhex("0488b21e")
    XPRV_VERBYTES = bytes.fromhex("0488ade4")
    RPC_PORT = 19205
    # Custom address format: voutxxxx23232323HiJklam
    P2PKH_VERBYTE = bytes.fromhex("46")  # 70 decimal = 0x46 (for 'v' prefix)
    P2SH_VERBYTES = (bytes.fromhex("84"),)  # 132 decimal = 0x84 (custom script)
    WIF_BYTE = bytes.fromhex("c6")  # 198 decimal = 0xc6 (private key format)
    GENESIS_HASH = ('000000000019d6689c085ae165831e93'
                    '4ff763ae46a2a6c172b3f1b60a8ce26f')  # Will be updated with actual Outcoin genesis
    SEGWIT_HRP = "out"
    # AuxPoW merge mining support
    AUXPOW_CHAIN_ID = 0x0062  # Unique Outcoin chain ID


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


class OutcoinTestnetMixin:
    SHORTNAME = "TOUT"
    NET = "testnet"
    XPUB_VERBYTES = bytes.fromhex("043587cf")
    XPRV_VERBYTES = bytes.fromhex("04358394")
    RPC_PORT = 19207
    P2PKH_VERBYTE = bytes.fromhex("6f")
    P2SH_VERBYTES = (bytes.fromhex("c4"),)
    WIF_BYTE = bytes.fromhex("ef")
    GENESIS_HASH = ('000000000933ea01ad0ee984209779ba'
                    'aec3ced90fa3f408719526f8d77f4943')
    SEGWIT_HRP = "tout"


class OutcoinTestnet(OutcoinTestnetMixin, Coin):
    NAME = "Outcoin"
    NET = "testnet"
    TX_COUNT = 10000
    TX_COUNT_HEIGHT = 100
    TX_PER_BLOCK = 50
    CRASH_CLIENT_VER = (3, 2, 3)
    PEERS = [
        'testnet-seed-1.outcoin.org s t',
        'testnet-seed-2.outcoin.org s t',
        'testnet-seed-3.outcoin.org s t',
    ]


class OutcoinRegtest(OutcoinTestnet):
    NET = "regtest"
    GENESIS_HASH = ('0f9188f13cb7b2c71f2a335e3a4fc328'
                    'bf5beb436012afca590b1a11466e2206')
    PEERS = []
    TX_COUNT = 1
    TX_COUNT_HEIGHT = 1 