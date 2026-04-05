# Tempo Dune Analytics Dashboard

Welcome to the **Tempo Blockchain Data Research Repository**. This project contains scripts, SQL queries, and ideation for creating a comprehensive Dune Analytics Dashboard focused on the Tempo blockchain.

## About Tempo

Tempo is a Layer 1 blockchain optimized specifically for stablecoin payments at scale. It operates with a few unique architectural differences from traditional EVM chains:
- **No Native Gas Token**: Gas fees are paid directly in USD-denominated stablecoins (USDC, USDT, etc.) via a Fee AMM.
- **Sub-Second Finality**: It runs on Simplex BFT consensus, producing deterministic blocks every ~0.5 seconds.
- **Ultra-Low Fees**: Transaction costs consistently target under $0.001.
- **Enshrined DEX**: A native decentralized exchange specifically built for stablecoins and tokenized deposits.
- **TIP-20 Standards**: Tokens follow the TIP-20 model, supporting currency identifiers, 32-byte memo fields, and transfer policies (TIP-403).

## Project Details

This workspace serves as a scratchpad and data exploration repository for researchers and agents building analytics for the Tempo ecosystem via DuneSQL.

### Included Resources
* `tempo.md` - Core chain architecture documentation and contract addresses.
* `GEMINI.md` - A complete brainstorming matrix defining the six primary pillars of the future comprehensive Dune Dashboard.
* `example.sql` - A compendium of optimized DuneSQL queries ready to be deployed.

## Core Queries Available

The queries currently built and available inside `example.sql` are strictly optimized with partition pruning to handle large datasets effectively on Dune Analytics.

1. **Stablecoin Supply Growth**: Tracks the net daily change and cumulative supply of Tempo fee-paying stablecoins, pulling from tokens metadata and transfers.
2. **Transactions Per Second (TPS)**: Analyzes network throughput down to the hourly level to observe spikes in volume.
3. **Transaction Costs**: Calculates the median and average gas fees across transactions, correctly converting stablecoin-denominated gas to human readable dollars.
4. **Unique Users & Cohort Tracking**: Segregates Daily Active Users (DAU) into "Net New" versus "Returning" to measure retention of the overall chain.
5. **Top Protocol Leaderboard**: Ranks the top 100 contracts interactively by their total gas spent, transactions captured, and unique origin users over the last 7 days.

## Operating Procedures
Since this repository relies heavily on Dune Analytics:
1. Ensure you have the `dune` CLI integrated (or use `.env` provided API keys).
2. When creating new queries on `tempo.transactions` or `tempo.traces`, **always use partition pruning** (`block_time >= NOW() - INTERVAL 'X' DAY`).
3. Be mindful of bigint overflows by casting integer rows to `DOUBLE` before computing large sums (`gas_price`, `gas_used`).
4. Read the `CLAUDE.md` instructions before operating or creating new SQL files. 
