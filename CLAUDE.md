# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Tempo blockchain data research repository**. It contains:
- Documentation about the Tempo stablecoin Layer 1 blockchain
- Example DuneSQL queries for analyzing Tempo chain data
- Custom Claude Code skills that provide CLI interfaces to Dune Analytics (query builder and real-time wallet lookups)

**Not a traditional software project** — there are no build steps, tests, or package managers. Instead, work involves writing DuneSQL queries and using CLI commands to interact with blockchain data.

## Core Skills & Commands

### Dune Skill (Query Builder)
Located in `.agents/skills/dune/`. Used for analytical queries and historical data analysis.

**Key commands:**
```bash
# Search for datasets to understand available tables
dune dataset search --query "stablecoin supply" --categories decoded --include-schema -o json

# Execute a one-off query
dune query run-sql --sql "SELECT * FROM tempo.transactions LIMIT 10" -o json

# Create and save a reusable query (requires confirmation)
dune query create --name "Query Name" --sql "..." -o json

# Run a saved query by ID
dune query run <query_id> -o json

# Check credit usage
dune usage -o json
```

**When to use Dune:** Custom SQL analytics, historical time-series, cross-address aggregations, large-scale data analysis.

**Important:** Always use `-o json` for JSON output (more detail than text format). For queries targeting partitioned tables, include WHERE filters on partition columns to enable partition pruning and reduce costs.

## Key Files & Structure

### Documentation
- **tempo.md** — Overview of the Tempo blockchain: no native gas token, sub-second finality, TIP-20 token standard, StablecoinDEX, EVM differences that affect data.
- **example.sql** — Real SQL examples for Tempo analysis:
  - Stablecoin supply tracking
  - Hourly transaction counts
  - Transaction costs and gas metrics
  - Transactions per second
  - Unique users analysis
  - Top contracts by gas spending
- **GEMINI.md** — Brainstorming document mapping out the core sections and focus areas for a complete Dune Dashboard for Tempo.
- **README.md** — User-facing documentation describing the project, data catalog, and SQL snippets.

### Important Tempo Context
- **No native gas token** — `value` fields in transactions/traces are not meaningful; token transfers happen via TIP-20/ERC-20 events.
- **TIP-20 events** — In addition to ERC-20 `Transfer` and `Approval`, Tempo emits: `TransferWithMemo`, `RewardDistributed`, `QuoteTokenUpdate`, `TransferPolicyUpdate`, `SupplyCapUpdate`.
- **Gas denominated in stablecoins** — `gas_price` and `max_fee_per_gas` are in stablecoins, not a native token.
- **Core contracts** — TIP-20 Factory, Fee Manager, Stablecoin DEX, TIP-403 Registry all have fixed addresses documented in tempo.md.

## Common Workflows

### Discover What Data Is Available
```bash
# Find all Tempo-related tables in Dune
dune dataset search --query "tempo" --include-schema -o json

# Search for a specific decoded contract
dune dataset search-by-contract --contract-address <address> --include-schema -o json
```

### Write and Test a Query
```bash
# Run SQL directly without saving
dune query run-sql --sql "SELECT COUNT(*) FROM tempo.transactions" -o json

# Once verified, save for reuse
dune query create --name "My Tempo Query" --sql "..." -o json
```

## DuneSQL Tips for Tempo

### Partition Pruning (MANDATORY)
If querying large tables like `tempo.transactions` or `tempo.traces`, always filter on `block_time` or `block_date`:
```sql
WHERE block_date >= CURRENT_DATE - INTERVAL '7' DAY
```
Failure to do this will result in query timeouts and excessive Dune credit usage.

### Bigint Overflows
When calculating gas costs or large balances, cast uint256 columns to `DOUBLE` *before* multiplying them to avoid `Bigint overflow` exceptions:
```sql
-- GOOD
(CAST(gas_price AS DOUBLE) * CAST(gas_used AS DOUBLE)) / 1E18
-- BAD
CAST(gas_price * gas_used AS DOUBLE) / 1E18
```

### Reserved Keywords
When querying fields like `to` and `from`, ensure they are wrapped in double quotes:
```sql
SELECT "to", "from" FROM tempo.transactions -- OK!
```

### TIP-20 vs ERC-20
Tempo uses TIP-20 (extended ERC-20). Query both event types if needed:
```sql
SELECT * FROM tip20_tempo.* -- TIP-20 events
UNION ALL
SELECT * FROM token_events.* -- Standard ERC-20 if present
```

### Fee Token Addresses
Tempo has zero-address (0x0000...) for native gas. Use `fee_token` field from `tempo.transactions` to identify stablecoins accepted for gas.

## Authentication

The Dune Query skill requires an API key:
- **Dune Query API:** Set via `dune auth` or `DUNE_API_KEY` env var

The CLI auto-installs on first use. If you hit authentication errors, see `.agents/skills/dune/references/install-and-recovery.md`.

## References

- **Tempo docs:** https://docs.tempo.xyz/
- **Dune docs:** https://docs.dune.com/
- **Dune Sim API:** https://sim.dune.com/
- **Example SQL:** See `example.sql` in this repo for real Tempo queries
