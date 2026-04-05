## SQL Example 

### 1. Tempo Stablecoin Supply (Fee Paying Stables Only)

WITH fee_tokens AS (
    SELECT DISTINCT fee_token AS contract_address
    FROM tempo.transactions
    WHERE block_time >= NOW() - INTERVAL '30' DAY -- Added partition pruning
),

-- 1. Token metadata (stable symbol per contract)
token_meta AS (
    SELECT
        contract_address,
        MAX(symbol) AS symbol
    FROM tokens.transfers
    WHERE blockchain = 'tempo'
    GROUP BY contract_address
),

-- 2. Date spine (continuous)
date_spine AS (
    SELECT d AS block_date
    FROM UNNEST(
        SEQUENCE(DATE '2026-01-01', CURRENT_DATE, INTERVAL '1' DAY)
    ) AS t(d)
),

-- 3. Tokens (filtered)
tokens AS (
    SELECT
        t.contract_address,
        m.symbol
    FROM fee_tokens t
    LEFT JOIN token_meta m
        ON t.contract_address = m.contract_address
    WHERE t.contract_address != 0x20c00000000000000000000016c6514b53947fdc
),

-- 4. Spine
spine AS (
    SELECT
        d.block_date,
        t.contract_address,
        t.symbol
    FROM date_spine d
    CROSS JOIN tokens t
),

-- 5. Flows
flows AS (
    SELECT
        block_date,
        contract_address,
        CASE
            WHEN "from" = 0x0000000000000000000000000000000000000000 THEN amount
            WHEN "to"   = 0x0000000000000000000000000000000000000000 THEN -amount
            ELSE 0
        END AS net_amount
    FROM tokens.transfers
    WHERE blockchain = 'tempo'
      AND contract_address != 0x20c00000000000000000000016c6514b53947fdc
),

-- 6. Daily net
daily_net AS (
    SELECT
        block_date,
        contract_address,
        SUM(net_amount) AS net_daily_change
    FROM flows
    GROUP BY block_date, contract_address
),

-- 7. Join spine
joined AS (
    SELECT
        s.block_date,
        s.contract_address,
        s.symbol,
        COALESCE(d.net_daily_change, 0) AS net_daily_change
    FROM spine s
    LEFT JOIN daily_net d
        ON s.block_date = d.block_date
       AND s.contract_address = d.contract_address
),

-- 8. Cumulative supply
final AS (
    SELECT
        block_date,
        contract_address,
        symbol,
        SUM(net_daily_change) OVER (
            PARTITION BY contract_address
            ORDER BY block_date
        ) AS supply
    FROM joined
)

SELECT *
FROM final
ORDER BY contract_address, block_date

### 2. Tempo: Hourly Successful Transactions

SELECT * FROM (
SELECT *, SUM(Transactions) OVER (ORDER BY hour) as "Cumulative Transactions" FROM (
SELECT date_trunc('hour', block_time) as hour, COUNT(DISTINCT hash) as Transactions FROM tempo.transactions
WHERE block_time >= NOW() - INTERVAL '30' DAY -- Added partition pruning
GROUP BY 1
)
GROUP BY 1,2
)

### 3. Tempo: Transaction Cost

SELECT DATE_TRUNC('hour', block_time) as hour, 
APPROX_PERCENTILE((CAST(gas_price AS DOUBLE) * CAST(gas_used AS DOUBLE))/1E18, 0.5) as "Median Transaction Cost (USDC.e)", -- Fixed bigint overflow
AVG((CAST(gas_price AS DOUBLE) * CAST(gas_used AS DOUBLE))/1E18) as "Average Transaction Cost (USDC.e)" -- Fixed bigint overflow
FROM tempo.transactions
WHERE block_time >= NOW() - INTERVAL '7' DAY -- Added partition pruning
GROUP BY 1

### 4. Tempo: Transactions Per Second

SELECT date_trunc('hour', block_time) as hour, COUNT(DISTINCT hash)/(60*60) as "Transactions Per Second" FROM tempo.transactions
WHERE block_time >= NOW() - INTERVAL '7' DAY -- Added partition pruning
GROUP BY 1

### 5. Tempo: Hourly Unique Users

with contracts as (
SELECT DISTINCT address FROM Tempo.traces
WHERE "type" = 'create'
AND success = True
AND address IS NOT NULL
AND code != 0x 
AND code IS NOT NULL
-- Added partition pruning
AND block_time >= NOW() - INTERVAL '30' DAY
),

daily as (
SELECT date_trunc('hour', block_time) as "Date", user as "User" FROM (
SELECT block_time, "to" as user FROM Tempo.transactions WHERE block_time >= NOW() - INTERVAL '30' DAY
UNION All
SELECT block_time, "from" FROM Tempo.transactions WHERE block_time >= NOW() - INTERVAL '30' DAY
)
WHERE user NOT IN (SELECT * FROM contracts)
),

oldandnew as (
SELECT "Date", new_users as "New", (unique_users - new_users) as "Old"
FROM (
SELECT sq."Date", COUNT(*) AS new_users
FROM ( 
SELECT "User" as unique_users, MIN("Date") AS "Date"
FROM daily
GROUP BY 1
ORDER BY 1
) sq
GROUP BY 1
) ssq LEFT JOIN (
SELECT "Date" AS "Date", COUNT(DISTINCT "User") AS unique_users
FROM daily
GROUP BY 1
ORDER BY 1
) t2 USING("Date")
ORDER BY 1 DESC
),

firstseen as (
SELECT MIN("Date") AS "Date", "User" as unique_users FROM daily
GROUP BY 2
)

SELECT * FROM (
SELECT DISTINCT f."Date", "New", "Old", COUNT(unique_users) OVER (ORDER BY f."Date") as "Cumulative Unique Users" FROM firstseen f
INNER JOIN oldandnew o ON f."Date" = o."Date"
)
WHERE "Date" >= DATE('2025-09-25')


### Tempo: Top Contracts (Last 7d)

with contracts as (
SELECT DISTINCT address FROM tempo.traces
WHERE "type" = 'create'
AND success = True
AND address IS NOT NULL
AND code != 0x 
AND code IS NOT NULL
AND block_time >= NOW() - interval '7' day -- Added partition pruning
)

SELECT
ROW_NUMBER() OVER(ORDER BY SUM(CAST(gas_used AS double) * CAST(gas_price AS double)) / 1e18 DESC) AS "Rank",  -- Fixed bigint overflow
get_href('https://explore.tempo.xyz/' || 'address/' || CAST("to" AS varchar), CAST("to" as varchar)) AS "Contract Address", -- Fixed unquoted 'to' reserved keyword
SUM(CAST(gas_used AS double) * CAST(gas_price AS double) / 1e18) AS "Gas Spent", -- Fixed bigint overflow
SUM(CAST(gas_used AS double) * CAST(gas_price AS double) / 1e18) AS "Gas Spent In USD", -- Fixed bigint overflow
COUNT(DISTINCT hash) AS Transactions, 
COUNT(DISTINCT "from") AS Users
FROM tempo.transactions p
INNER JOIN contracts c on p."to" = c.address -- Fixed unquoted 'to' reserved keyword
WHERE gas_price > 0
AND p.block_time >= NOW() - interval '7' day
GROUP BY 2
ORDER BY 1
LIMIT 100

### 7. Tempo "Coffee Index" (Payment Size Buckets)

SELECT
    CASE
        WHEN amount <= 5 THEN '1. Coffee (<$5)'
        WHEN amount <= 50 THEN '2. Lunch ($5-$50)'
        WHEN amount <= 500 THEN '3. Retail ($50-$500)'
        ELSE '4. Wholesale/Whale (>$500)'
    END as payment_tier,
    COUNT(*) as transaction_count,
    SUM(amount) as total_volume
FROM tokens.transfers
WHERE blockchain = 'tempo'
  AND block_time >= NOW() - INTERVAL '7' DAY
  AND amount > 0
  AND "from" != 0x0000000000000000000000000000000000000000 -- Exclude Mints
  AND "to" != 0x0000000000000000000000000000000000000000 -- Exclude Burns
GROUP BY 1
ORDER BY 1

### 8. Tempo POS & Invoice Adoption (Memo Usage)

SELECT 
    DATE_TRUNC('day', evt_block_time) as day,
    'Standard Transfer' as transfer_type,
    COUNT(*) as transactions
FROM tip20_tempo.TIP20_evt_Transfer
WHERE evt_block_time >= NOW() - INTERVAL '30' DAY
GROUP BY 1, 2

UNION ALL

SELECT 
    DATE_TRUNC('day', evt_block_time) as day,
    'Invoice (TransferWithMemo)' as transfer_type,
    COUNT(*) as transactions
FROM tip20_tempo.TIP20_evt_TransferWithMemo
WHERE evt_block_time >= NOW() - INTERVAL '30' DAY
GROUP BY 1, 2
ORDER BY 1 DESC, 2

### 9. Tempo Network EKG (Block Time Stability)

WITH block_deltas AS (
    SELECT
        block_time,
        block_number,
        DATE_DIFF('millisecond', lag(block_time) over (order by block_number), block_time) / 1000.0 as time_since_last_block
    FROM tempo.blocks
    WHERE block_time >= NOW() - INTERVAL '1' DAY
)
SELECT 
    DATE_TRUNC('minute', block_time) as minute,
    AVG(time_since_last_block) as avg_block_time_seconds,
    MAX(time_since_last_block) as max_block_time_seconds
FROM block_deltas
WHERE time_since_last_block IS NOT NULL
GROUP BY 1
ORDER BY 1
