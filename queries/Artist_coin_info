WITH config_txns AS (
  SELECT tx_id
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND block_time >= DATE '2025-10-07' 
    AND CARDINALITY(account_arguments) > 9
    AND account_arguments[1] = 'aDBCdATdhH3381hLjHPUjcg3DqdQ5cE5ke9fZDV9zbw'
),

second_config AS ( 
  SELECT account_arguments[1] AS config
  FROM solana.instruction_calls
  WHERE tx_success = TRUE
    AND block_time >= TRY_CAST('2025-10-07 00:00:00' AS TIMESTAMP)
    AND executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_signer = 'DDT15s6MMNxE4jkyGN46wNYqrgLWofT6WAvWtjYYrCUq'
    AND is_inner = FALSE
    AND CARDINALITY(account_arguments) = 8
),

config_list AS (
  SELECT DISTINCT config FROM second_config
),

second_config_txns AS (
  SELECT tx_id AS second_tx_id
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND block_time >= DATE '2025-10-07' 
    AND CARDINALITY(account_arguments) > 9
    AND account_arguments[1] IN (SELECT config FROM config_list)
),

joined_txns AS (
  SELECT
    COALESCE(ct.tx_id, sct.second_tx_id) AS tx_id,
    ct.tx_id            AS in_config_txns,
    sct.second_tx_id    AS in_second_config
  FROM config_txns ct
  FULL OUTER JOIN second_config_txns sct
    ON ct.tx_id = sct.second_tx_id
),

mint_transfer AS (
  SELECT DISTINCT 
    account_arguments[4]  AS token_mint_address,
    account_arguments[11] AS tx_signer,
    block_time,
    account_arguments[6]  AS pool,
    tx_id
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND block_time >= DATE '2025-10-07'
    AND tx_success = TRUE
    AND CARDINALITY(account_arguments) IN (16, 17)
    AND varbinary_starts_with(data, X'8C')  
    AND tx_id IN (SELECT tx_id FROM joined_txns)
),

excluded_tokens AS (
  SELECT DISTINCT token_mint_address FROM (VALUES
    -- existing exclusions
    ('jJ51dT4NL7G744CCKvT1ydykRmgALwiPpir2BeuxMP3'),
    ('JAJqxi1auVdn9Laqo5fS63qDrXfRWSdX8RNs4BcVk6nx'),
    ('W9mjaGt7PD2aqDzEj5vLRGgJ9xwW2wUaDs5fSEFxMP3'),
    ('AfvUtv8jLRKPm4r39HGF28r4y6JYmgo2RVBmXFC2mam6'),
    ('AWynZhdLJzq8TY5uFDGzftsX7K3U7BzisBFHBSVrMuZE'),
    ('AxczMs5GL8SRQPcR8McCcLK1WrG9yxKqckEf1y4Lp24G'),

    -- added mints (prior + latest request)
    ('X1oE1frxwCRMfbwvrKa1YNxf7ie8RCCKg4Ba6zJxYAK'),
    ('xncm17K7T36Y8XVXbZwCDnQzhw4L1t1eEUeBAeKxYAK'),
    ('QK4xJNMyxPEsu8R3UC9BCPkXrcSz2SQ1k6zZhaKxYAK'),
    ('KmdMTMV4s1fSPUPzb6N1Bsx4aNwhTv4YFTPBshcxYAK'),
    ('5oQM8wrky4KjSFmKLir5hHo3d9FJA6MrYd7smo8xYAK'),
    ('Mp72cgbVPBwiRXcmFpj1vjeXSptdkWEgLTi6oFqxYAK'),
    ('zuKPXGdxkgFSj7grPJ9vhYtNeozu3R2L1QtsWHCxYAK'),
    ('NuqPxnyj2vWfVPugjHCMjxPt6pJ6wPCTVSqcG5VxYAK'),

    -- other newly added mints from earlier lists
    ('5dERfGcirSDF65MgTGLLiiu8D86GYeGGW8ZUsRwxYAK'),
    ('ZhWBoPUJPFjgsXjAEFJty2Gbd9tAnUg7kMdKG9qxYAK'),
    ('vUEHbQ4DzUk3CDWBd9vvGAcv2ctvNwqTj5zQThLxYAK'),
    ('E5SYQTBsyPVKZsK1rj8ZyYASqt5AGezsqB9YQvzxYAK'),
    ('BqUC4Cp8aSDbMqczVFKMX6gt6qg8DaKZfDF2snxXAKMf'),
    ('ahbrvFBFBmQQaG6EuwC5KVMhVrmw3ncV2wMaghMxYAK'),
    ('wzzkog7fVaBbZAB8aBHwjafkFMXyNZMt6uu7E18xYAK'),
    ('12AxsafdqV6mnELXaGmXUPZa1FuNtLtJwo7evB4mxYAK'),
    ('8mtHKDRA9kX3bzzSS31BdcjZ9A9eDpAtrvVHwuAxYAK'),
    ('xdorayETtsYh3E93bNqxGU2MQbwAhHjAAyRg2VWxYAK'),
    ('H1EbLyaNsKuefhQ1sqnS8hsbXCfeAJdVnSU2YyaxYAK'),
    ('y6T3sRc2vnmoUaZyYooFTL3Ka7L33nEMHEVX8YCxYAK'),
    ('qdQ96MGTXWx9pmDb3mmPTgxXAAXHW8cUe4GngZgxYAK'),
    ('UnSHywsXeR7TFAkHq1EcRg8uM6oEtDeQSFNqQs4xYAK'),
    ('ZxRG5MSe8PDCQpKHyePv5KoBptpWKgDFhPirpCXxYAK'),
    ('aFgBnPeLth91B76JPXPjDV6uZk3HdxicHzYjJE9xYAK'),
    ('zMoewvHVZ9QBtJM1ERWVMYpNMdM9Tm63PdipB2vxYAK'),
    ('E5SYQTBsyPVKzS1rj8ZyYASqt5AGezsqB9YQvzxYAK'),
    ('jKTc7eBE7Y2sZmBmuxiVbSMwf7cnkik5uVE9q5SxYAK'),
    ('1Nq4pXEiRwuBGQwLosBZwKCHLb34oabtKyfQPbgxYAK'),
    ('PAM727hvLr5tmwHTNAdBGD4zfBAzPDbQ9sJxRcKxYAK'),
    ('cqiXFrykJrus8UrwqXmAjJUMefPZjifoURodwwXxYAK'),
    ('UXWsXKo1NuHALRZWo2DAZ46TgLy8c2dYKJFvgiaxYAK'),
    ('14LVgRPadB6W3FkDfZLwjhaMbznGvBDGb2VtFzoBxYAK'),
    ('EWh8mnHdgTCEJ65SBZatnF5321ZtQKgz3YuajzvxYAK'),
    ('bempLaj46WtCBu27ucRi4w1r7uxTpaMNNTaxkjKxYAK'),
    ('13uA8zdceAazLbMJ2djsUbErUWgjAdsbUU1rnG3AxYAK'),
    ('bzsLLB8ZUbjpdU4KmQEiby5iBn43tAEtuYjd9KvxYAK'),
    ('gx4Zuych8yXixTPsb8mVwfChXfcXTm8crLk7UMTxYAK'),
    ('jHXPN44accD8zwo3ndP7xCWKWoUTaFw4hDai5MUxYAK'),
    ('RFCBbhQpP95vJNbYZoUaXUDrvav1efreLCA6cs6xYAK'),
    ('vJdSoXGmnWC7hfKU7NByc1AEShaNn2asb1AhQGTxYAK'),
    ('Hs8b67yzguVY7rw2ybK5Q4AHemi1vBDS7chkzhqxYAK'),
    ('PnWXuN5LpnsHziFYW2CnJ9aazFeL9c6EEcVpwCaxYAK'),
    ('Pw7f8U1aP33bmJ2z8Yz5gJEWSNkvMdpgqZqwY9exYAK'),
    ('BqUC4Cp8aSDbMqczVFKMX6gt6q8DaKZfDF2snxXAKMf'),
    ('PiEJpRZtyGhUEEwr8vRbDYjhugekraVCJA5hJXpxYAK'),
    ('trRbZNLyWWYQq3D5py67KYe5nFBMeQUsHpsyP92xYAK')
  ) AS t(token_mint_address)
),

bespoke_tokens AS ( 
  SELECT 
    account_mint,
    mintAuthority AS deployerBT
  FROM spl_token_solana.spl_token_call_initializeMint2
  WHERE call_tx_signer = 'DDT15s6MMNxE4jkyGN46wNYqrgLWofT6WAvWtjYYrCUq' 
),

token_list AS (
  SELECT DISTINCT mt.token_mint_address
  FROM mint_transfer mt
  WHERE mt.token_mint_address NOT IN (SELECT token_mint_address FROM excluded_tokens)
  UNION
  SELECT DISTINCT bt.account_mint AS token_mint_address
  FROM bespoke_tokens bt
  WHERE bt.account_mint NOT IN (SELECT token_mint_address FROM excluded_tokens)
),

graduation_txns AS (
  SELECT 
    account_arguments[1] AS pool,
    block_time
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND block_time >= DATE '2025-10-07'
    AND CARDINALITY(account_arguments) > 3
    AND account_arguments[3] = 'aDBCdATdhH3381hLjHPUjcg3DqdQ5cE5ke9fZDV9zbw'
),

first_graduation AS (
  SELECT
    mt.token_mint_address,
    MIN(gt.block_time) AS first_graduation_block_time
  FROM mint_transfer mt
  JOIN graduation_txns gt
    ON mt.pool = gt.pool
  WHERE mt.token_mint_address IN (SELECT token_mint_address FROM token_list)
  GROUP BY mt.token_mint_address
), 

token_info AS (
  SELECT token_mint_address, symbol
  FROM tokens_solana.fungible
  WHERE token_mint_address IN (SELECT token_mint_address FROM token_list)
), 

-- SUPPLY (mirrors first query fallback)
token_supplies AS (
  SELECT 
    token_mint_address,
    COALESCE(NULLIF(SUM(token_balance), 0), 1000000000) AS total_supply
  FROM solana_utils.latest_balances
  WHERE token_mint_address IN (SELECT token_mint_address FROM token_list)
    AND token_balance > 0
  GROUP BY token_mint_address
),

holders AS (
  SELECT
    token_mint_address,
    COUNT(DISTINCT address) AS holder_count
  FROM solana_utils.latest_balances
  WHERE token_mint_address IN (SELECT token_mint_address FROM token_list)
    AND token_balance > 0
  GROUP BY token_mint_address
), 

-- PRICE (add daily-avg fallback like the first query)
latest_prices AS (
  SELECT token_mint_address, price, price_time
  FROM (
    SELECT
      contract_address AS token_mint_address,
      price,
      hour AS price_time,
      ROW_NUMBER() OVER (PARTITION BY contract_address ORDER BY hour DESC) AS rn
    FROM dex_solana.price_hour
    WHERE contract_address IN (SELECT token_mint_address FROM token_list)
  )
  WHERE rn = 1
),

latest_daily_avg AS (
  SELECT token_mint_address, avg_daily_price
  FROM (
    SELECT 
      contract_address AS token_mint_address,
      DATE(hour)       AS price_date,
      AVG(price)       AS avg_daily_price,
      ROW_NUMBER() OVER (
        PARTITION BY contract_address
        ORDER BY DATE(hour) DESC
      ) AS rn
    FROM dex_solana.price_hour
    WHERE contract_address IN (SELECT token_mint_address FROM token_list)
    GROUP BY contract_address, DATE(hour)
  )
  WHERE rn = 1
),

resolved_prices AS (
  SELECT
    tl.token_mint_address,
    COALESCE(lp.price, lda.avg_daily_price) AS price
  FROM token_list tl
  LEFT JOIN latest_prices    lp  ON tl.token_mint_address = lp.token_mint_address
  LEFT JOIN latest_daily_avg lda ON tl.token_mint_address = lda.token_mint_address
),

ath_market_caps AS (
  SELECT 
    ph.contract_address AS token_mint_address,
    MAX(ph.price) AS ath_price,
    MAX(ph.price * ts.total_supply) AS ath_market_cap
  FROM dex_solana.price_hour ph
  INNER JOIN token_supplies ts ON ph.contract_address = ts.token_mint_address
  WHERE ph.contract_address IN (SELECT token_mint_address FROM token_list)
    AND ph.price > 0
  GROUP BY ph.contract_address, ts.total_supply
),

volume_24h AS (
  SELECT 
    COALESCE(
      CASE WHEN token_bought_mint_address IN (SELECT token_mint_address FROM token_list) 
           THEN token_bought_mint_address END,
      token_sold_mint_address
    ) AS token_mint_address,
    SUM(amount_usd) AS volume_usd
  FROM dex_solana.trades
  WHERE block_time >= NOW() - INTERVAL '24' HOUR
    AND (token_bought_mint_address IN (SELECT token_mint_address FROM token_list)
         OR token_sold_mint_address IN (SELECT token_mint_address FROM token_list))
  GROUP BY 1
),

volume_all_time AS (
  SELECT 
    COALESCE(
      CASE WHEN token_bought_mint_address IN (SELECT token_mint_address FROM token_list) 
           THEN token_bought_mint_address END,
      token_sold_mint_address
    ) AS token_mint_address,
    SUM(amount_usd) AS volume_usd_all_time
  FROM dex_solana.trades
  WHERE block_time >= DATE '2025-10-05'
    AND (token_bought_mint_address IN (SELECT token_mint_address FROM token_list)
         OR token_sold_mint_address IN (SELECT token_mint_address FROM token_list))
  GROUP BY 1
),

main_results AS (
  SELECT
    mt.block_time AS launch_block_time,
    tl.token_mint_address AS token_address,
    ti.symbol,
    CASE
      WHEN ts.total_supply IS NULL OR ts.total_supply <= 0 THEN NULL
      WHEN rp.price IS NULL OR rp.price <= 0 THEN NULL
      WHEN h.holder_count BETWEEN 1 AND 10 AND (rp.price * ts.total_supply) > 500000000 THEN NULL
      ELSE rp.price * ts.total_supply
    END AS market_cap,
    ROUND(COALESCE(ath.ath_market_cap, 0), 2) AS ath_market_cap,
    COALESCE(h.holder_count, 0) AS holder_count,
    COALESCE(bt.deployerBT, mt.tx_signer) AS deployer,
    CASE
      WHEN bt.account_mint IS NOT NULL
        OR fg.first_graduation_block_time IS NOT NULL
      THEN '✅'
      ELSE '❌'
    END AS graduated,
    fg.first_graduation_block_time AS graduation_block_time,
    COALESCE(v.volume_usd, 0) AS volume_24h,
    COALESCE(vat.volume_usd_all_time, 0) AS volume_all_time
  FROM token_list tl
  LEFT JOIN mint_transfer    mt  ON tl.token_mint_address = mt.token_mint_address
  LEFT JOIN token_info       ti  ON tl.token_mint_address = ti.token_mint_address
  LEFT JOIN holders          h   ON tl.token_mint_address = h.token_mint_address
  LEFT JOIN first_graduation fg  ON tl.token_mint_address = fg.token_mint_address
  LEFT JOIN resolved_prices  rp  ON tl.token_mint_address = rp.token_mint_address
  LEFT JOIN token_supplies   ts  ON tl.token_mint_address = ts.token_mint_address
  LEFT JOIN ath_market_caps  ath ON tl.token_mint_address = ath.token_mint_address
  LEFT JOIN volume_24h       v   ON tl.token_mint_address = v.token_mint_address
  LEFT JOIN volume_all_time  vat ON tl.token_mint_address = vat.token_mint_address
  LEFT JOIN bespoke_tokens   bt  ON tl.token_mint_address = bt.account_mint
)

SELECT * FROM main_results
UNION ALL
SELECT
  NULL AS launch_block_time,
  'TOTAL' AS token_address,
  NULL AS symbol,
  SUM(market_cap) AS market_cap,
  ROUND(SUM(ath_market_cap), 2) AS ath_market_cap,
  NULL AS holder_count,
  NULL AS deployer,
  NULL AS graduated,
  NULL AS graduation_block_time,
  SUM(volume_24h) AS volume_24h,
  SUM(volume_all_time) AS volume_all_time
FROM main_results
ORDER BY 
  CASE WHEN token_address = 'TOTAL' THEN 1 ELSE 0 END,
  market_cap DESC NULLS LAST;
