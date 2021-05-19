# contract-sdk-cpp
The C plus plus ontract SDK for XuperChain smart contract

###  Dependencies 

 [![Docker ](https://docs.docker.com/engine/install/)](https://docs.docker.com/engine/install/)
 [![Xdev ](https://github.com/xuperchain/xdev)](https://github.com/xuperchain/xdev)

### Build and run unit tests 
1. Clone Source Code
    ``` bash
        git clone https://github.com/xuperchain/contract-sdk-cpp.git
    ```
    
1. Build Contract SDK 
    
    ``` bash
        make build
    ```
1. Run unitest

    ``` bash
        make test
    ```
   
   
### Examples
You can use examples to getting start with XuperChain, explore XuperChain features.
   
1. Build Examples
    
    ``` bash
        make build-example 
    ```
2. Run example test
  
    ``` bash
        make example-test
    ```
3. Use in your DAPP 

|  **Example** | **Description** | **Documentation** |
| -------------|------------------------------|------------------|
| [Award Manage](commercial-paper) | Explore a use case and detailed application development tutorial in which two organizations use a blockchain network to trade commercial paper. | [Commercial paper tutorial](https://hyperledger-fabric.readthedocs.io/en/latest/tutorial/commercial_paper.html) |
| [Charity Demo](off_chain_data) | Learn how to use the Peer channel-based event services to build an off-chain database for reporting and analytics. | [Peer channel-based event services](https://hyperledger-fabric.readthedocs.io/en/latest/peer_event_services.html) |
| [Counter](token-erc-20) | Smart contract demonstrating how to create and transfer fungible tokens using an account-based model. | [README](token-erc-20/README.md) |
| [Game Assets](token-utxo) | Smart contract demonstrating how to create and transfer fungible tokens using a UTXO (unspent transaction output) model. | [README](token-utxo/README.md) |
| [Hash Deposit](high-throughput) | Learn how you can design your smart contract to avoid transaction collisions in high volume environments. | [README](high-throughput/README.md) |
| [Luck Draw](auction) | Run an auction where bids are kept private until the auction is closed, after which users can reveal their bid | [README](auction/README.md) |
| [Score Record](chaincode) | A set of other sample smart contracts, many of which were used in tutorials prior to the asset transfer sample series. | |
| [Short Content](interest_rate_swaps) | **Deprecated in favor of state based endorsement asset transfer sample** | |
| [Source Trace](fabcar) | **Deprecated in favor of basic asset transfer sample** |  |
### Contributions 

We weleome contribution in any form(feature, issue, documention etc.), Visit [![Contribution Guide ](https://xuper.baidu.com/n/xuperdoc/contribution/pull_requests.html)](https://xuper.baidu.com/n/xuperdoc/contribution/pull_requests.html) for more information of contributing to XuperChain