WITH
excluded_tokens AS (
  SELECT DISTINCT token_mint_address FROM (VALUES
    -- existing exclusions
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
  ) AS t(token_mint_address)
),



bespoke_events AS (
  SELECT
    account_mint    AS token_mint_address,
    call_block_time AS block_time
  FROM spl_token_solana.spl_token_call_initializeMint2
  WHERE call_tx_signer = 'DDT15s6MMNxE4jkyGN46wNYqrgLWofT6WAvWtjYYrCUq'
    AND NOT EXISTS (
      SELECT 1
      FROM excluded_tokens et
      WHERE et.token_mint_address = account_mint
    )
),

config_txns AS (
  SELECT tx_id
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND CARDINALITY(account_arguments) > 9
    AND account_arguments[1] = 'aDBCdATdhH3381hLjHPUjcg3DqdQ5cE5ke9fZDV9zbw'
    AND block_time >= TIMESTAMP '2025-10-07 00:00:00'
),

second_config AS (
  SELECT account_arguments[1] AS config
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND is_inner = FALSE
    AND CARDINALITY(account_arguments) = 8
    AND tx_signer = 'DDT15s6MMNxE4jkyGN46wNYqrgLWofT6WAvWtjYYrCUq'
    AND block_time >= TIMESTAMP '2025-10-07 00:00:00'
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
    AND block_time >= TIMESTAMP '2025-10-07 00:00:00'
),

token_launches AS (
  SELECT 
    account_arguments[4]  AS token_mint_address,
    account_arguments[11] AS tx_signer,
    block_time,
    account_arguments[6]  AS pool,
    tx_id
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND tx_success = TRUE
    AND block_time >= TIMESTAMP '2025-10-07 00:00:00'
    AND CARDINALITY(account_arguments) IN (16, 17)
    AND varbinary_starts_with(data, X'8C')
    AND tx_id IN (SELECT tx_id FROM txs_for_configs)
    AND account_arguments[4] NOT IN (SELECT token_mint_address FROM excluded_tokens)
),

token_launches_all AS (
  SELECT token_mint_address, tx_signer, block_time, pool, tx_id
  FROM token_launches
  UNION
  SELECT
    be.token_mint_address,
    CAST(NULL AS VARCHAR) AS tx_signer,
    be.block_time,
    CAST(NULL AS VARCHAR) AS pool,
    CAST(NULL AS VARCHAR) AS tx_id
  FROM bespoke_events be
),

mint_transfer AS (
  SELECT DISTINCT 
    account_arguments[4] AS token_mint_address,
    account_arguments[11] AS tx_signer,
    block_time,
    account_arguments[6] AS pool
  FROM solana.instruction_calls
  WHERE executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND block_time >= DATE '2025-10-07'
    AND tx_success = TRUE
    AND CARDINALITY(account_arguments) IN (16, 17)
    AND varbinary_starts_with(data, X'8C')
    AND tx_id IN (SELECT tx_id FROM txs_for_configs)
    AND account_arguments[4] NOT IN (SELECT token_mint_address FROM excluded_tokens)
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
  GROUP BY mt.token_mint_address
),

first_graduation_all AS (
  SELECT token_mint_address, first_graduation_block_time
  FROM first_graduation
  UNION
  SELECT token_mint_address, block_time AS first_graduation_block_time
  FROM bespoke_events
),

per_token_first_launch AS (
  SELECT
    t.token_mint_address,
    MIN(t.block_time) AS first_launch_block_time
  FROM token_launches_all t
  WHERE NOT EXISTS (
    SELECT 1 FROM excluded_tokens et
    WHERE et.token_mint_address = t.token_mint_address
  )
  GROUP BY t.token_mint_address
),

daily_metrics AS (
  SELECT
    CAST(first_launch_block_time AS DATE) AS date,
    COUNT(DISTINCT token_mint_address)    AS launched_tokens,
    0                                     AS graduated_tokens,
    0                                     AS daily_tx_signers
  FROM per_token_first_launch
  GROUP BY CAST(first_launch_block_time AS DATE)

  UNION ALL

  SELECT
    CAST(first_graduation_block_time AS DATE) AS date,
    0                                         AS launched_tokens,
    COUNT(DISTINCT token_mint_address)        AS graduated_tokens,
    0                                         AS daily_tx_signers
  FROM first_graduation_all
  GROUP BY CAST(first_graduation_block_time AS DATE)

  UNION ALL

  SELECT
    CAST(block_time AS DATE) AS date,
    0                        AS launched_tokens,
    0                        AS graduated_tokens,
    COUNT(DISTINCT tx_signer) AS daily_tx_signers
  FROM token_launches
  GROUP BY CAST(block_time AS DATE)
),

aggregated_daily AS (
  SELECT
    date,
    SUM(launched_tokens)  AS launched_tokens,
    SUM(graduated_tokens) AS graduated_tokens,
    SUM(daily_tx_signers) AS daily_tx_signers
  FROM daily_metrics
  WHERE date IS NOT NULL
  GROUP BY date
),

date_series AS (
  SELECT d AS date
  FROM UNNEST(
    SEQUENCE(DATE '2025-10-07', CURRENT_DATE, INTERVAL '1' DAY)
  ) AS t(d)
),

aggregated_with_zeros AS (
  SELECT
    ds.date,
    COALESCE(ad.launched_tokens,  0) AS launched_tokens,
    COALESCE(ad.graduated_tokens, 0) AS graduated_tokens,
    COALESCE(ad.daily_tx_signers, 0) AS daily_tx_signers
  FROM date_series ds
  LEFT JOIN aggregated_daily ad
    ON ad.date = ds.date
),

final_metrics AS (
  SELECT
    date,
    launched_tokens,
    graduated_tokens,
    daily_tx_signers,
    SUM(launched_tokens)  OVER (ORDER BY date ROWS UNBOUNDED PRECEDING) AS cumulative_launched_tokens,
    SUM(graduated_tokens) OVER (ORDER BY date ROWS UNBOUNDED PRECEDING) AS cumulative_graduated_tokens,
    SUM(daily_tx_signers) OVER (ORDER BY date ROWS UNBOUNDED PRECEDING) AS cumulative_tx_signers,
    SUM(launched_tokens)  OVER (ORDER BY date RANGE BETWEEN INTERVAL '2' DAY PRECEDING AND CURRENT ROW) AS launched_tokens_last_3_days,
    SUM(graduated_tokens) OVER (ORDER BY date RANGE BETWEEN INTERVAL '2' DAY PRECEDING AND CURRENT ROW) AS graduated_tokens_last_3_days,
    SUM(launched_tokens)  OVER (ORDER BY date RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND CURRENT ROW) AS launched_tokens_last_7_days,
    SUM(graduated_tokens) OVER (ORDER BY date RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND CURRENT ROW) AS graduated_tokens_last_7_days
  FROM aggregated_with_zeros
)

SELECT *
FROM final_metrics
ORDER BY date DESC;
