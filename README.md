# contract-sdk-cpp
The C plus plus contract SDK for  [![XuperChain](https://github.com/xuperchain/xuperchain.git)](https://github.com/xuperchain/xuperchain.git) smart contract
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
You can use examples to getting start with XuperChain, explore XuperChain features or in your DAPP 
   
1. Build Examples
    
    ``` bash
    make build-example 
    ```
2. Run example test
  
    ``` bash
    make test-example
    ```
3. Use in your DAPP 

|  **Example** | **Description** | **Documentation** |
| -------------|------------------------------|------------------|
| [Award Manage](commercial-paper) | An digital award management contract example which can be used in Business operation activities | [DOC](https://hyperledger-fabric.readthedocs.io/en/latest/tutorial/commercial_paper.html) |
| [Charity Demo](off_chain_data) | A smart contract which stores charity donate and cost on blockchain | [DOC](https://hyperledger-fabric.readthedocs.io/en/latest/peer_event_services.html) |
| [Counter](token-erc-20) | An as simple as possible example of smart contract which implements a decentralized Counter| [DOC](token-erc-20/README.md) |
| [Game Assets](token-utxo) | An assets management contract example set at game asset, you can extend it to any  NFT situation | [DOC](token-utxo/README.md) |
| [Hash Deposit](high-throughput) | A file  deposit contract example,in which file hash is stored on blockchain | [DOC](high-throughput/README.md) |
| [Luck Draw](auction) | A decentralized luck draw game  | [DOC](auction/README.md) |
| [Score Record](chaincode) |An example of content deposit contract which store student grades on blockchain | |
| [Short Content](interest_rate_swaps) | An example of content deposit, which implement store and query by  content field  | |
| [Source Trace](fabcar) | An example contract of source trace |  |

### Contributions 

We weleome contribution in any form(feature, issue, documention etc.), See [![Contribution Guide ](https://xuper.baidu.com/n/xuperdoc/contribution/pull_requests.html)](https://xuper.baidu.com/n/xuperdoc/contribution/pull_requests.html) for more information of contributing to XuperChain