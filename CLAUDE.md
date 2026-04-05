# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Tempo blockchain data research repository**. It contains:
- Documentation about the Tempo stablecoin Layer 1 blockchain
- Example DuneSQL queries for analyzing Tempo chain data
- A custom Claude Code skill that provides a CLI interface to Dune Analytics

**Not a traditional software project** — there are no build steps, tests, or package managers. Work involves writing DuneSQL queries and using CLI commands to interact with blockchain data.

## Core Skill & Commands

### Dune Skill (Query Builder)
Located in `.agents/skills/dune/`. Used for analytical queries and historical data analysis.

**Key commands:**
```bash
# Search for datasets to understand available tables
dune dataset search --query "stablecoin supply" --categories decoded --include-schema -o json

# Execute a one-off query
dune query run-sql --sql "SELECT * FROM tempo.transactions LIMIT 10" -o json

# Create and save a reusable query (requires confirmation before running)
dune query create --name "Query Name" --sql "..." -o json

# Run a saved query by ID
dune query run <query_id> -o json

# Check credit usage
dune usage -o json
```

Always use `-o json` for JSON output (more detail than text format).

## Key Files

- **tempo.md** — Tempo blockchain architecture, contract addresses, and EVM differences that affect data.
- **example.sql** — Optimized DuneSQL queries ready to deploy (supply, TPS, fees, users, contracts, Coffee Index, EKG).
- **tempo_dash.md** — Comprehensive dashboard brainstorm with confirmed Dune table names and query strategy.
- **gemini_dash.md** — Additional dashboard ideas focusing on payment-first metrics (Coffee Index, Merchant Memo, Network EKG).
- **README.md** — Project overview and operating procedures.

## Important Tempo Context

- **No native gas token** — `value` fields in transactions/traces are not meaningful; token transfers happen via TIP-20/ERC-20 events.
- **Gas denominated in stablecoins** — `gas_price` and `max_fee_per_gas` are in stablecoins, not a native token. Use `fee_token` column in `tempo.transactions` to identify which stablecoin paid gas.
- **TIP-20 events** — Beyond standard ERC-20 `Transfer`/`Approval`, Tempo emits: `TransferWithMemo`, `RewardDistributed`, `QuoteTokenUpdate`, `TransferPolicyUpdate`, `SupplyCapUpdate`, `BurnBlocked`, `PauseStateUpdate`.
- **Sub-second finality** — ~0.5s blocks via Simplex BFT; no re-orgs.

## Confirmed Dune Tables for Tempo

**Canonical:**
- `tempo.transactions` — `hash`, `block_time`, `block_date`, `from`, `to`, `gas_used`, `gas_price`, `fee_token`
- `tempo.traces` — `type`, `success`, `address`, `code` (use `type='create'` for contract deployments)
- `tempo.blocks` — block timing and finality data

**TIP-20 spell tables:**
- `tip20_tempo.evt_transfer`, `tip20_tempo.evt_transferwithmemo`
- `tip20_tempo.evt_mint`, `tip20_tempo.evt_burn`, `tip20_tempo.evt_rewarddistributed`
- `tip20_tempo.evt_supplycapupdate`, `tip20_tempo.evt_transferpolicyupdate`
- `tip20_tempo.evt_burnblocked`, `tip20_tempo.evt_pausestateupdate`

**Cross-chain spell tables** (filter `blockchain = 'tempo'`):
- `tokens.transfers` — enriched transfers with `amount_usd`, `symbol`, `price_usd`
- `tokens.erc20` — token metadata

**StablecoinDEX (CLOB order book, not AMM):**
- `tempoexchange_tempo.stablecoindex_evt_orderplaced`
- `tempoexchange_tempo.stablecoindex_evt_orderfilled`
- `tempoexchange_tempo.stablecoindex_evt_ordercancelled`
- `tempoexchange_tempo.stablecoindex_call_swapexactamountin`
- `tempoexchange_tempo.stablecoindex_call_swapexactamountout`

**Other DeFi:**
- `erc4626_tempo.evt_deposit` / `erc4626_tempo.evt_withdraw`
- `uniswap_v2_multichain.*` / `uniswap_v4_multichain.*` — filter `chain = 'tempo'`

## DuneSQL Tips for Tempo

### Partition Pruning (MANDATORY)
Always filter on `block_time` or `block_date` when querying `tempo.transactions` or `tempo.traces`:
```sql
WHERE block_date >= CURRENT_DATE - INTERVAL '7' DAY
```
Failure causes query timeouts and excessive credit usage.

### Bigint Overflows
Cast `uint256` columns to `DOUBLE` *before* multiplying:
```sql
-- GOOD
(CAST(gas_price AS DOUBLE) * CAST(gas_used AS DOUBLE)) / 1E18
-- BAD: overflows
CAST(gas_price * gas_used AS DOUBLE) / 1E18
```

### Reserved Keywords
Wrap `to` and `from` in double quotes:
```sql
SELECT "to", "from" FROM tempo.transactions
```

### Amount Normalization
Tempo tokens use 18 decimals. Divide raw `amount` values by `1e18` for human-readable output.

## Common Workflows

### Discover Available Tables
```bash
dune dataset search --query "tempo" --include-schema -o json
dune dataset search-by-contract --contract-address <address> --include-schema -o json
```

### Write and Test a Query
```bash
# Test without saving
dune query run-sql --sql "SELECT COUNT(*) FROM tempo.transactions WHERE block_date = CURRENT_DATE" -o json

# Save once verified
dune query create --name "My Tempo Query" --sql "..." -o json
```

## Authentication

Set the Dune API key via `dune auth` or `DUNE_API_KEY` env var. If auth fails, see `.agents/skills/dune/references/install-and-recovery.md`.

## References

- **Tempo docs:** https://docs.tempo.xyz/
- **Dune docs:** https://docs.dune.com/