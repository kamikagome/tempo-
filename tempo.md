> ## Documentation Index


### Stablecoin addresses

These addresses are the same on both mainnet and testnet:
Token	Address
pathUSD	0x20c0000000000000000000000000000000000000
AlphaUSD	0x20c0000000000000000000000000000000000001
BetaUSD	0x20c0000000000000000000000000000000000002
ThetaUSD	0x20c0000000000000000000000000000000000003

### System Contracts

Core protocol contracts that power Tempo's features.

Contract	Address	Description
TIP-20 Factory	0x20fc000000000000000000000000000000000000	Create new TIP-20 tokens
Fee Manager	0xfeec000000000000000000000000000000000000	Handle fee payments and conversions
Stablecoin DEX	0xdec0000000000000000000000000000000000000	Enshrined DEX for stablecoin swaps
TIP-403 Registry	0x403c000000000000000000000000000000000000	Transfer policy registry
pathUSD	0x20c0000000000000000000000000000000000000	First stablecoin deployed


Standard Utilities
Popular Ethereum contracts deployed for convenience.

Contract	Address	Description
Multicall3	0xcA11bde05977b3631167028862bE2a173976CA11	Batch multiple calls in one transaction
CreateX	0xba5Ed099633D3B313e4D5F7bdc1305d3c28ba5Ed	Deterministic contract deployment
Permit2	0x000000000022d473030f116ddee9f6b43ac78ba3	Token approvals and transfers
Arachnid Create2 Factory	0x4e59b44847b379578588920cA78FbF26c0B4956C	CREATE2 deployment proxy
Safe Deployer	0x914d7Fec6aaC8cd542e72Bca78B30650d45643d7	Safe deployer contract

> Fetch the complete documentation index at: https://docs.dune.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Tempo Chain Overview

> Tempo blockchain data on Dune

## What is Tempo?

Tempo is a Layer 1 blockchain purpose-built for stablecoin payments at scale. Incubated by Paradigm and Stripe, Tempo is built on Paradigm's high-performance Ethereum client Reth and uses Simplex BFT consensus for sub-second, deterministic finality. It is fully EVM-compatible, allowing developers to use familiar Solidity tooling like Foundry and Hardhat.

Tempo is often referred to as a "stablechain" because its entire design is optimized around stablecoin-based payments rather than general-purpose computation.

## Key Features of Tempo

### **No Native Gas Token**

Unlike virtually every other blockchain, Tempo has no native cryptocurrency. Gas fees are paid directly in USD-denominated stablecoins (USDC, USDT, etc.) via a Fee AMM that converts user-selected fee tokens to validator-preferred assets. This means `value` fields in transactions and traces behave differently than on other EVM chains — there is no native ETH-like asset being transferred.

### **Sub-Second Finality**

Tempo produces blocks every \~0.5 seconds with deterministic, immediate finality powered by Simplex BFT consensus. Once a block is committed, it is final with no re-orgs or probabilistic finality.

### **Ultra-Low Fees**

Transaction costs target under \$0.001 per transaction, with dedicated payment lanes that reserve blockspace for payment transactions to ensure low fees even during congestion.

### **TIP-20 Token Standard**

Tempo extends ERC-20 with its own TIP-20 standard, adding currency identifiers (USD, EUR), gas payment capability, a 32-byte memo field for invoice IDs and metadata, reward distribution mechanisms, and compliance policy integration. TIP-20 events are indexed on Dune under `tip20_tempo.*` tables alongside standard ERC-20 tables.

### **Built-in StablecoinDEX**

A native decentralized exchange optimized for stablecoin conversions and tokenized deposits. The StablecoinDEX is decoded on Dune under `tempoexchange_tempo.stablecoindex_*` tables.

## EVM Differences Impacting Data

While Tempo is EVM-compatible, several design choices affect how data appears compared to standard EVM chains:

* **No native token**: The `value` field in transactions and traces is not meaningful in the traditional sense since there is no native gas token. Token transfers happen via TIP-20/ERC-20 events instead.
* **TIP-20 events**: In addition to standard ERC-20 `Transfer` and `Approval` events, Tempo tokens emit TIP-20-specific events like `TransferWithMemo`, `RewardDistributed`, `QuoteTokenUpdate`, `TransferPolicyUpdate`, and `SupplyCapUpdate`.
* **Gas paid in stablecoins**: Gas fee fields (`gas_price`, `max_fee_per_gas`) denominate fees in stablecoins rather than a native token, which affects `gas.fees` computations.

<CardGroup cols={1}>
  <Card title="Tempo documentation" icon="link" href="https://docs.tempo.xyz">
    Access full documentation for Tempo, including architecture, token standards, and developer guides.
  </Card>
</CardGroup>

## Data Catalog

<CardGroup cols={2}>
  <Card title="Logs" icon="bolt" href="./raw/logs">
    Smart contract event logs on Tempo.
  </Card>

  <Card title="Blocks" icon="cubes" href="./raw/blocks">
    Information on processed blocks, highlighting Tempo's sub-second throughput.
  </Card>

  <Card title="Transactions" icon="message-arrow-up" href="./raw/transactions">
    Data on transactions, illustrating Tempo's ultra-low-cost stablecoin payments.
  </Card>

  <Card title="Decoded" icon="file" href="./decoded/overview">
    Decoded transaction data for in-depth analysis of contract executions including the native StablecoinDEX and Uniswap deployments.
  </Card>
</CardGroup>


> ## Documentation Index
> Fetch the complete documentation index at: https://docs.dune.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Tempo Chain Decoded Overview

> Simplifying Tempo Chain smart contract analysis through human-readable tables.

export const DuneEmbed = ({qID, vID, height = '500px'}) => <>
    <div className="hidden dark:block">
      <iframe src={`https://dune.com/embeds/${qID}/${vID}?darkMode=true`} style={{
  width: '100%',
  height,
  border: 'none',
  marginTop: '10px'
}}></iframe>
    </div>
    <div className="dark:hidden">
      <iframe src={`https://dune.com/embeds/${qID}/${vID}`} style={{
  width: '100%',
  height,
  border: 'none',
  marginTop: '10px'
}}></iframe>
    </div>
  </>;

export const OverviewDecodedDataApproach = ({blockchain}) => <div>
    <h2>Overview of Dune's Decoded Data Approach</h2>
    <p>
      Dune uses the ABI (Application Binary Interface) of smart contracts to decode blockchain transactions into structured tables. Each event log and function call from the ABI are parsed into their own tables. This decoding process transforms the raw, encoded data on the blockchain into human-readable tables, simplifying the analysis of smart contract data.
    </p>
    <p>Dune's decoded data approach offers several benefits:</p>
    <ul>
      <li><strong>Enhanced Readability:</strong> The decoded data tables provide a clear and intuitive representation of smart contract activities.</li>
      <li><strong>Efficient Analysis:</strong> The structured tables enable efficient querying and analysis of smart contract data.</li>
      <li><strong>Handling Multiple Contract Instances:</strong> For smart contracts with multiple instances, Dune aggregates the data from these instances into a single table, simplifying the analysis process.</li>
      <li><strong>Collaborative Mapping:</strong> Dune's smart contract library is continuously expanded through the active participation of the Dune community, ensuring that the decoding coverage remains comprehensive and current.</li>
    </ul>
    
    <CardGroup cols={2}>
      <Card title="Explore decoded logs" icon="circle-bolt" iconType="duotone" href={`/data-catalog/evm/${blockchain}/decoded/event-logs`}></Card>
      <Card title="Explore decoded traces" icon="layer-group" iconType="duotone" href={`/data-catalog/evm/${blockchain}/decoded/call-tables`}></Card>
    </CardGroup>

    <h2>Which contracts have decoded data?</h2>
    <p>
      Contract submission on Dune are driven by the community. Usually, the odds are good that the contract you are looking at is already decoded, but especially for new projects or new contracts, it might be that the contract is not decoded yet. In those cases, you can submit the contract to be decoded. Decoding usually takes about 24 hours, in special cases it might take longer.
    </p>
    <p>
      You can check if contracts are already decoded by querying the <code>[blockchain].contracts</code> tables, the <a href="/web-app/query-editor/data-explorer">data explorer</a>, or use <a href="https://dune.com/dune/is-my-contract-decoded-yet-v2">this dashboard</a>.
    </p>
    <CardGroup cols={2}>
      <Card title="Submit any contract for decoding" icon="file-import" iconType="duotone" href="/web-app/decoding-contracts"></Card>
      <Card title="Explore already decoded contracts" icon="database" iconType="duotone" href={`/data-catalog/evm/${blockchain}/decoded/contracts`}></Card>
    </CardGroup>

    
    <h2>How does decoding work?</h2>
    <p>
      Smart Contracts on any EVM blockchain are mostly written in high-level languages like <a href="https://docs.soliditylang.org/en/v0.8.2">Solidity</a> or <a href="https://vyper.readthedocs.io/en/stable">Vyper</a>. In order for them to be deployed to an EVM execution environment, they need to be compiled to EVM executable bytecode. Once deployed, the bytecode gets associated with an address on the respective chain and is permanently stored in the chain's state storage.
    </p>
    <p>
      To be able to interact with this smart contract, which is now just bytecode, we need a guide to call the functions defined in the high-level languages. This translation of names and arguments into byte representation is done using an <strong>Application Binary Interface (ABI)</strong>. The ABI documents names, types, and arguments precisely, which allows us to interact with the smart contract using a somewhat human-readable format. The ABI can be compiled using the high-level language source code.
    </p>
    <p><strong>The ABI is used to call a smart contract or interpret the data it emits.</strong></p>
    <img src="/data-catalog/images/decoding.png" alt="Decoding process illustration" />

    <h2>Decoding Example</h2>
    <p>
      We are going to look at an event log of an ERC20 transfer event from the <a href="https://etherscan.io/token/0x429881672B9AE42b8EbA0E26cD9C73711b891Ca5#readContract">smart contract</a> that represents the $PICKLE token. On <a href="https://etherscan.io/tx/0x2bb7c8283b782355875fa37d05e4bd962519ea294678a3dcf2fdffbbd0761bc5#eventlog">Etherscan</a>, the undecoded event looks like this:
    </p>
    <img src="/data-catalog/images/etherscan.png" alt="Etherscan event log screenshot" />

    <p>
      If we query for this transaction in the `ethereum.logs` table in the Dune database, we will receive the same encoded bytecode as our result dataset.
    </p>
    <pre><code>{`SELECT *
FROM ethereum.logs
WHERE tx_hash = 0x2bb7c8283b782355875fa37d05e4bd962519ea294678a3dcf2fdffbbd0761bc5
`}</code></pre>

    <div>
      <DuneEmbed qID="3455255" vID="5806543" height="200px" />
    </div>

    <p>
      We could make short work of this encoded bytecode by using <a href="/query-engine/Functions-and-operators/varbinary">DuneSQL Varbinary functions</a> to decode it, but having the contract's ABI at hand makes this process much easier. <br />
      This contract is decoded in Dune, so we can use the <code>pickle_finance_ethereum.PickleToken_evt_Transfer</code> table to access the decoded event log.
    </p>
    <pre><code>{`SELECT *
FROM pickle_finance_ethereum.PickleToken_evt_Transfer
WHERE evt_tx_hash = 0x2bb7c8283b782355875fa37d05e4bd962519ea294678a3dcf2fdffbbd0761bc5`}</code></pre>

    <div>
      <DuneEmbed qID="3455274" vID="5806581" height="200px" />
    </div>

    <p><strong>Now this is actually useful for analyzing this transaction!</strong></p>
    <p> This data is much more readable and understandable than the encoded bytecode. We can see the sender, receiver, and the amount of tokens transferred in this event log.</p>


    <h2>How do I understand decoded data?</h2>
    <p>
      Decoded data is the high level programming language representation of two pieces of software talking to each other via the blockchain.
    </p>
    <p>
      It's not always easy for a human to understand what exactly is going on in these interactions, but most of the time, looking at column names and the data that is transmitted within them should help you to understand what is happening within that specific log or call.
    </p>
    <p>
      If you are not able to make sense of the data by just searching the tables, it usually helps to look at single transactions using the transaction hash and <a href="https://etherscan.io">Etherscan</a>.
    </p>
    <p>
      Furthermore, going into the code of the smart contract (our favorite way to do this is <a href="https://etherscan.deth.net">DethCode</a>) to read the comments or the actual logic can help to understand the smart contract's emitted data.
    </p>
    <p>
      If that also doesn't lead to satisfactory results, scouring the relevant docs and GitHub of the project can lead you to the desired answers. Furthermore, talking to the developers and core community of a project can also help you to get an understanding of the smart contracts.
    </p>

  </div>;

<OverviewDecodedDataApproach blockchain="tempo" />

Tempo official docs https://docs.tempo.xyz/


