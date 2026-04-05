# Comprehensive Tempo Dashboard Ideas

A brainstorm for building a multi-faceted Dune dashboard that showcases Tempo's unique capabilities as a stablechain.

## Dashboard Sections

### 1. Network Health & Performance (Hero Metrics)
**Key insight:** Showcase Tempo's technical superiority in speed, throughput, and finality.

**Cards:**
- **Current Transactions Per Second (TPS)** — Real-time rolling average (last 1 min, 5 min, 1 hour)
- **Average Block Time** — Should be ~0.5 seconds (deterministic finality)
- **Unique Active Addresses (24h)** — Daily snapshot
- **Unique Smart Contracts (24h)** — Developer activity
- **Blocks Created (24h)** — Measure of network liveness
- **Cumulative Transactions** — All-time counter

**Visualizations:**
- Line chart: TPS over time (hourly bucketing) — compare to Ethereum/other L1s
- Gauge: Current block time vs. target (0.5s)
- Heatmap: Hourly transaction activity (day-of-week × hour)

---

### 2. Stablecoin Activity (Payment Focus)
**Key insight:** Tempo is optimized for stablecoin payments; this section proves product-market fit.

**Cards:**
- **Total Stablecoin Supply** — Sum across pathUSD, AlphaUSD, BetaUSD, ThetaUSD
- **Daily Stablecoin Transfers (count)** — Raw transaction volume
- **Daily Stablecoin Transfer Volume (USD)** — Aggregate notional value
- **Top Stablecoin by Usage** — By transfer count and volume
- **Stablecoin Holders (unique addresses)** — Adoption metric
- **Daily Active Stablecoin Users** — Cumulative unique senders/receivers

**Visualizations:**
- Stacked area chart: Supply over time for each stablecoin (pathUSD, AlphaUSD, BetaUSD, ThetaUSD)
- Column chart: Daily transfer volume (USD) vs. transfer count
- Pie chart: Market share by transfer volume among the 4 stablecoins
- Time-series line: Daily/cumulative stablecoin holder count (adoption curve)
- Heatmap: Top stablecoin pairs (from → to addresses) by volume

---

### 3. Transaction Economics (Fee Efficiency)
**Key insight:** Ultra-low fees are Tempo's competitive advantage.

**Cards:**
- **Median Transaction Cost (USD equivalent)** — Show sub-$0.001 target
- **Average Transaction Cost (USD equivalent)**
- **Cost per KB of calldata** — Efficiency metric
- **Total Fees Collected (24h)** — In USD
- **Fee Token Distribution** — Which stablecoins are used for gas?
- **Cumulative Fees Collected** — All-time

**Visualizations:**
- Box plot or percentile chart: Transaction cost distribution (0th, 25th, 50th, 75th, 99th percentile)
- Time-series line: Median/average fees over time (trend)
- Bar chart: Fees by transaction size (small, medium, large)
- Pie chart: Fee token composition (which stablecoin funds gas?)
- Histogram: Transaction cost distribution (bins for $0-0.0001, $0.0001-0.001, etc.)

---

### 4. Token Activity (TIP-20 Ecosystem)
**Key insight:** TIP-20 standard is a core differentiator; show adoption.

**Cards:**
- **Total TIP-20 Tokens Created** — Cumulative count
- **TIP-20 Tokens with Activity (24h)** — Active ecosystem
- **TIP-20 Transfer Events (24h)** — vs. standard ERC-20
- **TransferWithMemo Events (24h)** — Unique TIP-20 feature adoption
- **Top TIP-20 Tokens by Transfer Count**
- **Top TIP-20 Tokens by Unique Senders**

**Visualizations:**
- Line chart: Cumulative TIP-20 tokens created over time
- Grouped bar chart: TIP-20 transfers vs. standard ERC-20 transfers (daily)
- Table: Top 10 TIP-20 tokens (by transfer count, unique holders, transfers/day)
- Pie chart: Distribution of TIP-20 event types (TransferWithMemo vs. standard Transfer)
- Scatter plot: Token age vs. current activity (discovery plot)

---

### 5. StablecoinDEX Activity (Built-In Order Book)
**Key insight:** The native StablecoinDEX is a CLOB (Central Limit Order Book), not an AMM — it has order placement, fills, and cancellations. This is unusual for a DEX and worth showcasing.

**Available tables:** `tempoexchange_tempo.stablecoindex_evt_orderfilled`, `stablecoindex_evt_orderplaced`, `stablecoindex_evt_ordercancelled`, `stablecoindex_call_swapexactamountin`, `stablecoindex_call_swapexactamountout`, `stablecoindex_evt_paircreated`

**Cards:**
- **Daily Swap Volume (USD)** — Via `swapexactamountin/out` calls (amountIn × token price)
- **Daily Orders Placed / Filled / Cancelled**
- **Order Fill Rate** — filled ÷ (placed + filled) — liquidity quality metric
- **Most Active Trading Pairs** — `tokenIn → tokenOut` from swap calls
- **Cumulative Swap Volume (USD)**
- **Unique Traders (24h)**
- **Average Fill Size**

**Visualizations:**
- Line chart: Daily order placements vs. fills vs. cancellations
- Bar chart: Top trading pairs by volume (tokenIn/tokenOut)
- Funnel: Orders placed → filled vs. cancelled
- Scatter plot: Order size vs. fill probability
- Time-series: Bid/ask activity ratio over time

---

### 5b. Tokenized Vaults (ERC4626)
**Key insight:** ERC4626 vault activity shows institutional/DeFi deposit patterns.

**Available tables:** `erc4626_tempo.evt_deposit`, `erc4626_tempo.evt_withdraw`

**Cards:**
- **Total Assets Deposited (USD)**
- **Total Shares Issued**
- **Unique Vault Depositors**
- **Active Vaults (24h)**
- **Net Flow (deposits − withdrawals)**

**Visualizations:**
- Area chart: Cumulative deposits vs. withdrawals over time
- Bar chart: Top vaults by TVL (assets held)
- Line chart: Daily net flow

---

### 6. DeFi & Contract Deployment
**Key insight:** Tempo is EVM-compatible; Uniswap V2 and V4 are already deployed alongside the native StablecoinDEX.

**Available tables:** `tempo.traces` (contract creation), `uniswap_v2_multichain.*` (chain='tempo'), `uniswap_v4_multichain.*` (chain='tempo')

**Cards:**
- **Deployed Smart Contracts (all-time)** — from `tempo.traces WHERE type='create'`
- **New Contracts Deployed (24h)**
- **Uniswap V2 Pairs Created** — from `uniswap_v2_multichain.factory_evt_paircreated`
- **Top Contracts by Gas Spent (24h)**
- **Top Contracts by Unique Interaction Count**
- **Contract Failure Rate** — Reverted vs. successful transactions

**Visualizations:**
- Line chart: Cumulative contracts deployed over time
- Table: Top 20 contracts by interaction count (annotated: StablecoinDEX, Uniswap Router, etc.)
- Bar chart: Daily new contract deployments
- Pie chart: Known protocol breakdown (StablecoinDEX vs. Uniswap V2/V4 vs. other)
- Bubble chart: Contract age vs. gas spent vs. unique callers

---

### 7. User Cohorts & Network Growth
**Key insight:** Track adoption and user retention.

**Cards:**
- **Total Users (all-time)** — Unique sender/receiver addresses
- **Daily Active Users (DAU)**
- **Monthly Active Users (MAU)**
- **Weekly Active Users (WAU)**
- **New Users (24h)**
- **User Retention Rate (day-over-day)**

**Visualizations:**
- Line chart: DAU, WAU, MAU trends (stacked or separate)
- Cohort table: Retention by signup cohort (day/week/month)
- Bar chart: New users per day
- Funnel chart: Users who signed up → made 1 tx → made 5+ txs → made 50+ txs
- Histogram: Transaction frequency per user (whale vs. retail)

---

### 8. Validator & Consensus Metrics
**Key insight:** Leverage Simplex BFT and sub-second finality.

**Cards:**
- **Active Validators**
- **Average Block Time (milliseconds)** — Should be ~500ms
- **Block Time Consistency** — Std deviation (measure of finality guarantees)
- **Blocks with Full Capacity** — Congestion metric
- **Blocks by Validator** — Distribution (detect centralization)
- **Finality Rate** — Should be 100% (no reorgs)

**Visualizations:**
- Line chart: Block time over time (should be flat ~500ms)
- Histogram: Block time distribution
- Bar chart: Blocks by validator (concentration)
- Time-series: Block size trend (adoption)
- Gauge: Average block time vs. target

---

### 9. Payment Flows & Corridors (Advanced)
**Key insight:** Understand real-world payment patterns.

**Cards:**
- **Top User Pairs (payment corridors)** — Most frequent sender→receiver pairs
- **Top Receiving Addresses (merchants?)** — By incoming volume
- **Top Sending Addresses (treasuries?)** — By outgoing volume
- **Intra-vs-Inter Country Flows** — If address geolocation available
- **Average Payment Size** — By stablecoin
- **Payment Frequency (repeat customers)**

**Visualizations:**
- Sankey: Top payment flows (accounts → merchant accounts)
- Map: Geographic distribution of users (if geolocation available)
- Bar chart: Receiving address profiles by volume tier
- Time-series: Payment frequency (same-origin-to-destination pairs recurring)
- Network graph: Top 100 users connected by transactions

---

### 10. Fee Economics & Validator Rewards
**Key insight:** Understand protocol economics.

**Cards:**
- **Daily Fee Revenue (USD)** — Sum of (gas_price × gas_used)
- **Cumulative Fee Revenue (USD)**
- **Average Fee per Transaction**
- **Fee Token Composition** — Which stablecoins pay fees?
- **Validator Share** — Estimated per-validator reward (if distributed)
- **Protocol Sustainability** — Fee trend vs. network growth

**Visualizations:**
- Stacked area: Daily fees by fee token type
- Line chart: Cumulative fee revenue over time
- Bar chart: Fee revenue per week/month
- Pie chart: Fee token distribution
- Scatter: Transaction count vs. daily fees (correlation)

---

### 11. Smart Contract Ecosystem Heat Map
**Key insight:** Show concentration of activity.

**Cards:**
- **Top Contracts by Daily Interaction**
- **Contracts by Category** — Estimated (DEX, token, bridge, etc.)
- **Contract Code Reuse** — How many are copies/forks?
- **Protocol Forks** (e.g., Uniswap clones on Tempo)
- **Supply Chain Dependencies** — Which contracts are used together?

**Visualizations:**
- Network graph: Contract interactions (A calls B calls C)
- Bubble chart: Contract age, gas spent, unique callers (3D)
- Time-series: New contract categories per day
- Dependency tree: Most-used contracts and what depends on them

---

### 12. Comparative Benchmarks (Cross-Chain Context)
**Key insight:** Show Tempo's positioning.

**Cards:**
- **Tempo TPS vs. Ethereum vs. Solana vs. Layer 2s**
- **Tempo Avg Fee vs. Competitors**
- **Tempo Block Time vs. Competitors**
- **Tempo DAU vs. Competitors** (if cross-chain data available)

**Visualizations:**
- Bar chart: TPS comparison (Tempo as hero)
- Bar chart: Fee comparison (Tempo as hero)
- Scatter: Decentralization (# validators) vs. TPS (positioning)

---

## Dashboard Layout Suggestion

**Top Row (4 hero cards):**
- Current TPS | Median Fee (USD) | DAU | Cumulative Volume (USD)

**Second Row (Key trends - 3 charts):**
- TPS over time (line chart)
- Daily stablecoin transfer volume (area chart)
- Cumulative users (line chart)

**Section 1 - Network Health (2 charts):**
- Block time distribution | Transactions per second heatmap

**Section 2 - Stablecoins (3 charts):**
- Supply by coin (stacked area) | Transfer volume by coin (pie) | Holder growth (line)

**Section 3 - Fees & Economics (2 charts):**
- Cost distribution (box plot) | Fee revenue over time (line)

**Section 4 - DeFi & Contracts (2 charts):**
- Top contracts table | New contracts per day (bar)

**Section 5 - User Growth (2 charts):**
- DAU/WAU/MAU trends | User cohort retention

**Section 6 - Advanced (1-2 tables):**
- Top payment corridors | Top receiving addresses

---

## Query Strategy

1. **Use window functions** for trends (cumulative sums, running averages)
2. **Partition by date** for daily aggregations (enables partition pruning)
3. **Use CTEs** to avoid duplication (fee calculation, user definition, etc.)
4. **Cache intermediate results** for expensive CTEs (e.g., all-time unique users)
5. **Confirmed Tempo tables on Dune:**

   **Canonical:**
   - `tempo.transactions` — columns: `hash`, `block_time`, `from`, `to`, `gas_used`, `gas_price`, `fee_token` (Tempo-specific!)
   - `tempo.traces` — columns: `type`, `success`, `address`, `code` (use `type='create'` for contract deployments)
   - `tempo.blocks` — block timing and finality data

   **TIP-20 spell tables:**
   - `tip20_tempo.evt_transfer` — standard token transfers
   - `tip20_tempo.evt_transferwithmemo` — transfers with memo field (invoice IDs)
   - `tip20_tempo.evt_mint` / `tip20_tempo.evt_burn` — supply changes
   - `tip20_tempo.evt_rewarddistributed` — reward distributions
   - `tip20_tempo.evt_supplycapupdate` — supply cap governance
   - `tip20_tempo.evt_transferpolicyupdate` — compliance policy changes
   - `tip20_tempo.evt_burnblocked` — blocked burns (compliance)
   - `tip20_tempo.evt_pausestateupdate` — token pause state

   **Cross-chain spell tables (filter `blockchain = 'tempo'`):**
   - `tokens.transfers` — enriched transfers with `amount_usd`, `symbol`, `price_usd`
   - `tokens.erc20` — token metadata (symbol, decimals)
   - `erc20_tempo.evt_transfer` — raw ERC-20 transfers

   **StablecoinDEX (Order Book, not AMM):**
   - `tempoexchange_tempo.stablecoindex_evt_orderplaced`
   - `tempoexchange_tempo.stablecoindex_evt_orderfilled`
   - `tempoexchange_tempo.stablecoindex_evt_ordercancelled`
   - `tempoexchange_tempo.stablecoindex_call_swapexactamountin`
   - `tempoexchange_tempo.stablecoindex_call_swapexactamountout`
   - `tempoexchange_tempo.stablecoindex_evt_paircreated`

   **Other DeFi:**
   - `erc4626_tempo.evt_deposit` / `erc4626_tempo.evt_withdraw` — vault activity
   - `uniswap_v2_multichain.*` — filter `chain = 'tempo'`
   - `uniswap_v4_multichain.*` — filter `chain = 'tempo'`

---

## Creative / Experimental Sections

**If you want to go deeper:**

1. **MEV Detection** — Analyze transaction ordering within blocks
2. **Payment Lane Utilization** — If Tempo allocates lanes for payments vs. general compute
3. **Invoice Metadata Analysis** — Parse the 32-byte `memo` field from `tip20_tempo.evt_transferwithmemo` for patterns (recurring invoice IDs, merchant codes)
4. **Compliance Events Dashboard** — Track `tip20_tempo.evt_burnblocked`, `evt_pausestateupdate`, `evt_transferpolicyupdate` for compliance/regulatory activity
5. **Sentiment & Activity Cycles** — Identify weekly/monthly patterns (B2B payroll, settlement cycles)
6. **Smart Contract Upgrades** — Track proxy patterns and upgrade events
7. **Order Book Depth Analysis** — StablecoinDEX bid/ask placement patterns, cancel rates, fill latency
8. **Fee Token Arbitrage** — Do users pick cheaper fee tokens? Track trends via `fee_token` column in `tempo.transactions`
9. **Spam Detection** — Identify dust transactions vs. real activity
10. **Validator Centralization Risk** — Monitor stake distribution, proposal concentration
11. **ERC4626 Vault Yield Tracking** — Track deposit/withdraw cycles to infer yield-seeking behavior
