WITH 
bespoke_events AS (
  SELECT
    account_mint    AS token_mint_address,
    call_block_time AS block_time,
    CAST(NULL AS VARCHAR) AS tx_signer,
    CAST(NULL AS VARCHAR) AS pool
  FROM spl_token_solana.spl_token_call_initializeMint2
  WHERE call_tx_signer = 'DDT15s6MMNxE4jkyGN46wNYqrgLWofT6WAvWtjYYrCUq'
    AND DATE(call_block_time) >= DATE '2025-10-07'
),

config_txns AS (
  SELECT tx_id
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND CARDINALITY(account_arguments) > 9
    AND account_arguments[1] = 'aDBCdATdhH3381hLjHPUjcg3DqdQ5cE5ke9fZDV9zbw'
    AND DATE(block_time) >= DATE '2025-10-07'
    AND DATE(block_time) <= DATE '2025-11-05'
),

second_config AS (
  SELECT account_arguments[1] AS config
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND is_inner = FALSE
    AND CARDINALITY(account_arguments) = 8
    AND tx_signer = 'DDT15s6MMNxE4jkyGN46wNYqrgLWofT6WAvWtjYYrCUq'
    AND DATE(block_time) >= DATE '2025-10-07'
),

configs AS (
  SELECT 'aDBCdATdhH3381hLjHPUjcg3DqdQ5cE5ke9fZDV9zbw' AS config
  UNION
  SELECT DISTINCT config FROM second_config
),

txs_for_configs AS (
  SELECT DISTINCT tx_id
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND CARDINALITY(account_arguments) > 9
    AND account_arguments[1] IN (SELECT config FROM configs)
    AND DATE(block_time) >= DATE '2025-10-07'
),

token_launches AS (
  SELECT DISTINCT 
    ic.account_arguments[4]  AS token_mint_address,
    ic.account_arguments[11] AS tx_signer,
    ic.block_time,
    ic.account_arguments[6]  AS pool
  FROM solana.instruction_calls ic
  WHERE ic.executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND ic.tx_success = TRUE
    AND CARDINALITY(ic.account_arguments) IN (16, 17)
    AND DATE(ic.block_time) >= DATE '2025-10-07'
    AND varbinary_starts_with(ic.data, X'8C')
    AND ic.tx_id IN (SELECT tx_id FROM txs_for_configs)
),

token_launches_all AS (
  SELECT token_mint_address, tx_signer, block_time, pool FROM token_launches
  UNION ALL
  SELECT token_mint_address, tx_signer, block_time, pool FROM bespoke_events
),

/* =========================
   Excluded token mint list
   ========================= */
excluded_tokens (token_mint_address) AS (
  VALUES
    ('jJ51dT4NL7G744CCKvT1ydykRmgALwiPpir2BeuxMP3'),
    ('JAJqxi1auVdn9Laqo5fS63qDrXfRWSdX8RNs4BcVk6nx'),
    ('W9mjaGt7PD2aqDzEj5vLRGgJ9xwW2wUaDs5fSEFxMP3'),
    ('AfvUtv8jLRKPm4r39HGF28r4y6JYmgo2RVBmXFC2mam6'),
    ('AWynZhdLJzq8TY5uFDGzftsX7K3U7BzisBFHBSVrMuZE'),
    ('AxczMs5GL8SRQPcR8McCcLK1WrG9yxKqckEf1y4Lp24G'),
    ('X1oE1frxwCRMfbwvrKa1YNxf7ie8RCCKg4Ba6zJxYAK'),
    ('xncm17K7T36Y8XVXbZwCDnQzhw4L1t1eEUeBAeKxYAK'),
    ('QK4xJNMyxPEsu8R3UC9BCPkXrcSz2SQ1k6zZhaKxYAK'),
    ('KmdMTMV4s1fSPUPzb6N1Bsx4aNwhTv4YFTPBshcxYAK'),
    ('5oQM8wrky4KjSFmKLir5hHo3d9FJA6MrYd7smo8xYAK'),
    ('Mp72cgbVPBwiRXcmFpj1vjeXSptdkWEgLTi6oFqxYAK'),
    ('zuKPXGdxkgFSj7grPJ9vhYtNeozu3R2L1QtsWHCxYAK'),
    ('NuqPxnyj2vWfVPugjHCMjxPt6pJ6wPCTVSqcG5VxYAK'),
    ('5dERfGcirSDF65MgTGLLiiu8D86GYeGGW8ZUsRwxYAK'),
    ('ZhWBoPUJPFjgsXjAEFJty2Gbd9tAnUg7kMdKG9qxYAK'),
    ('vUEHbQ4DzUk3CDWBd9vvGAcv2ctvNwqTj5zQThLxYAK'),
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
    ('E5SYQTBsyPVKZsK1rj8ZyYASqt5AGezsqB9YQvzxYAK'),
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
    ('BqUC4Cp8aSDbMqczVFKMX6gt6qg8DaKZfDF2snxXAKMf'),
    ('PiEJpRZtyGhUEEwr8vRbDYjhugekraVCJA5hJXpxYAK'),
    ('trRbZNLyWWYQq3D5py67KYe5nFBMeQUsHpsyP92xYAK')
),

token_first_launches AS (
  SELECT
    t.token_mint_address,
    MIN(t.block_time) AS launch_block_time,
    MIN_BY(t.tx_signer, t.block_time) AS tx_signer
  FROM token_launches_all t
  WHERE t.token_mint_address NOT IN (SELECT token_mint_address FROM excluded_tokens)
  GROUP BY t.token_mint_address
),

latest_prices AS (
  SELECT
    contract_address AS token_mint_address,
    MAX_BY(price, hour) AS price,     -- last observed price
    MAX(hour)          AS price_hour
  FROM dex_solana.price_hour
  WHERE contract_address IN (SELECT token_mint_address FROM token_first_launches)
  GROUP BY contract_address
),

latest_daily_avg AS (
  SELECT token_mint_address, avg_daily_price
  FROM (
    SELECT 
      contract_address AS token_mint_address,
      DATE(hour)       AS price_date,
      AVG(price)       AS avg_daily_price,
      ROW_NUMBER() OVER (PARTITION BY contract_address ORDER BY DATE(hour) DESC) AS rn
    FROM dex_solana.price_hour
    WHERE contract_address IN (SELECT token_mint_address FROM token_first_launches)
    GROUP BY contract_address, DATE(hour)
  )
  WHERE rn = 1
),

resolved_prices AS (
  SELECT
    tfl.token_mint_address,
    COALESCE(lp.price, lda.avg_daily_price) AS price
  FROM token_first_launches tfl
  LEFT JOIN latest_prices    lp  ON tfl.token_mint_address = lp.token_mint_address
  LEFT JOIN latest_daily_avg lda ON tfl.token_mint_address = lda.token_mint_address
),

token_supplies AS (
  SELECT 
    tl.token_mint_address,
    COALESCE(NULLIF(SUM(lb.token_balance), 0), 1000000000) AS effective_supply
  FROM token_first_launches tl
  LEFT JOIN solana_utils.latest_balances lb
    ON tl.token_mint_address = lb.token_mint_address
   AND lb.token_balance > 0
  GROUP BY tl.token_mint_address
),

token_data AS (
  SELECT
    tfl.launch_block_time,
    tfl.token_mint_address,
    rp.price,
    ts.effective_supply,
    CASE
      WHEN rp.price IS NOT NULL
      THEN rp.price * ts.effective_supply
      ELSE NULL
    END AS market_cap
  FROM token_first_launches tfl
  LEFT JOIN resolved_prices rp ON tfl.token_mint_address = rp.token_mint_address
  LEFT JOIN token_supplies  ts ON tfl.token_mint_address = ts.token_mint_address
)

SELECT
  COUNT *        AS token_count,        
  SUM(market_cap) AS total_market_cap,
  AVG(market_cap) AS average_market_cap
FROM token_data
WHERE market_cap IS NOT NULL;
