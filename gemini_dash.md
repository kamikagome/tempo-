# 🕊️ Gemini Dashboard Ideas: The Tempo "Payments First" Strategy

Building a dashboard for Tempo requires moving past standard "DeFi" metrics and focusing on its core value proposition: a frictionless, ultra-fast, stablecoin-based payment network.

## 🚀 High-Impact Creative Concepts

### 1. ☕ The "Coffee Index" (Retail Adoption)
*   **The Idea:** Traditional chains are dominated by large swaps. Tempo's value is in micro-payments.
*   **The Viz:** A histogram breaking transactions into buckets: `<$5` (Coffee), `$5-$50` (Lunch), `$50-$500` (Retail), and `>$500` (Wholesale).
*   **The Impact:** Proves Tempo is used for "real world" small-ticket items, justifying its sub-$0.001 fee structure.

### 2. 🧾 The Merchant Adoption Tracker (TIP-20 Memos)
*   **The Idea:** TIP-20's 32-byte memo field is designed for Payment IDs/Invoices.
*   **The Viz:** Compare total transfers to `TransferWithMemo` counts over time.
*   **The Impact:** Quantifies how many transactions are actually part of a professional merchant/invoice flow versus simple peer-to-peer transfers.

### 3. 🫀 The Network EKG (Finality Stability)
*   **The Idea:** Tempo claims deterministic ~0.5s finality through Simplex BFT.
*   **The Viz:** Plot the delta between consecutive block timestamps over the last 24 hours.
*   **The Impact:** Visually demonstrates the "Heartbeat" of the chain. A perfectly flat line at 0.5s builds massive institutional trust in the network's liveness and reliability.

### 4. ⛽ Gas Currency Market Share
*   **The Idea:** Users can pay gas in various stablecoins.
*   **The Viz:** Pie chart of gas fees paid by `fee_token` (USDC, USDT, pathUSD, etc.).
*   **The Impact:** Reveals user preference for "Unit of Account" for transaction costs.

---

## 🛠️ Validated SQL Patterns for Tempo

Through our review, we've identified the following critical patterns for writing efficient, accurate Tempo queries on Dune:

### ✅ Correct Table Mappings
Decoded TIP-20 tables follow the lowercase `evt_` pattern under the `tip20_tempo` namespace:
-   `tip20_tempo.evt_transfer`
-   `tip20_tempo.evt_transferwithmemo`

### ✅ Mandatory Partition Pruning
Always include a time-based filter to prevent timeouts on the massive `tempo.transactions` and `tempo.traces` tables:
```sql
WHERE block_time >= NOW() - INTERVAL '7' DAY
```

### ✅ Bigint Safety
Avoid Bigint overflow failures when multiplying huge numbers (like gas_price * gas_used) by casting to `DOUBLE` first:
```sql
(CAST(gas_price AS DOUBLE) * CAST(gas_used AS DOUBLE)) / 1e18
```

### ✅ Raw Amount Normalization
Tempo tokens often use 18 decimals. For human-readable charts, always divide raw `amount` values (stored in `tokens.transfers` or decoded events) by `1e18`.

---

## 🗺️ Next Steps: Implementation Path

1.  **Phase 1: Macro Heartbeat.** Port the "Network EKG" and "TPS" queries to Dune dashboards.
2.  **Phase 2: Payment Analysis.** Implement the "Coffee Index" and "Merchant Memo" metrics.
3.  **Phase 3: Economic Hub.** Build the "Stablecoin Supply" and "Gas Currency" charts.
