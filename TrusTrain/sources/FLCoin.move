module TrusTrain::FLCoin{
    use aptos_framework::coin;
    use std::string;
    use std::signer;

    struct FLC{}

    const E_NO_ADMIN: u64 = 1;
    const E_NO_CAPABILITIES: u64 = 2;
    const E_HAS_CAPABILITIES: u64 = 3;
    struct Capabilities<phantom FLCoin> has key {
        burn_cap: coin::BurnCapability<FLCoin>,
        freeze_cap: coin::FreezeCapability<FLCoin>,
        mint_cap: coin::MintCapability<FLCoin>,
    }
    public entry fun initialize(account: &signer) {
        let (burn_cap, freeze_cap, mint_cap) = coin::initialize<FLC>(
            account,
            string::utf8(b"FL Token"),
            string::utf8(b"FLC"),
            100,
            true,
        );
        assert!(signer::address_of(account)==@TrusTrain,E_NO_ADMIN);
        assert!(exists<Capabilities<FLC>>(@TrusTrain), E_HAS_CAPABILITIES );

        move_to(account, Capabilities<FLC>{
            burn_cap,
            freeze_cap,
            mint_cap,
        });
    }
public fun mint<FLC>(
        account: &signer,
        amount: u64,
    ): coin::Coin<FLC> acquires Capabilities {
        let account_addr = signer::address_of(account);

        assert!(signer::address_of(account)==@TrusTrain,E_NO_ADMIN);
        assert!(exists<Capabilities<FLC>>(account_addr),E_NO_CAPABILITIES);

        let mint_capabilities = &borrow_global<Capabilities<FLC>>(account_addr).mint_cap;
        coin::mint<FLC>(amount, mint_capabilities)
    }
    public fun burn(coins: coin::Coin<FLC>) acquires Capabilities{
    let burn_capabilities = &borrow_global<Capabilities<FLC>>(@TrusTrain).burn_cap;
    coin::burn<FLC>(coins,burn_capabilities);
}


        
}