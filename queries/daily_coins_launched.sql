WITH
params AS (
  SELECT DATE '2025-10-07' AS start_date, CURRENT_DATE AS end_date
),

days AS (
  SELECT d AS day_date
  FROM params p
  CROSS JOIN UNNEST(SEQUENCE(p.start_date, p.end_date, INTERVAL '1' DAY)) AS t(d)
),

second_config AS (
  SELECT DISTINCT ic.account_arguments[1] AS config
  FROM solana.instruction_calls ic
  JOIN params p ON TRUE
  WHERE ic.tx_success = TRUE
    AND ic.block_time >= p.start_date
    AND ic.block_time <  p.end_date + INTERVAL '1' DAY
    AND ic.executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND ic.tx_signer = 'DDT15s6MMNxE4jkyGN46wNYqrgLWofT6WAvWtjYYrCUq'
    AND ic.is_inner = FALSE
    AND CARDINALITY(ic.account_arguments) = 8
),

txs_for_configs AS (
  SELECT DISTINCT ic.tx_id
  FROM solana.instruction_calls ic
  JOIN params p ON TRUE
  WHERE ic.block_time >= p.start_date
    AND ic.block_time <  p.end_date + INTERVAL '1' DAY
    AND ic.executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND ic.tx_success = TRUE
    AND CARDINALITY(ic.account_arguments) > 9
    AND (
         ic.account_arguments[1] = 'aDBCdATdhH3381hLjHPUjcg3DqdQ5cE5ke9fZDV9zbw'
         OR EXISTS (
           SELECT 1 FROM second_config sc
           WHERE sc.config = ic.account_arguments[1]
         )
    )
),

mint_transfer AS (
  SELECT DISTINCT
      CAST(ic.block_time AS DATE) AS day_date,
      ic.account_arguments[4]     AS token_mint_address
  FROM solana.instruction_calls ic
  JOIN params p ON TRUE
  WHERE ic.block_time >= p.start_date
    AND ic.block_time <  p.end_date + INTERVAL '1' DAY
    AND ic.executing_account = 'dbcij3LWUppWqq96dh6gJWwBifmcGfLSB5D4DuSMaqN'
    AND ic.tx_success = TRUE
    AND CARDINALITY(ic.account_arguments) IN (16, 17)
    AND varbinary_starts_with(ic.data, X'8C')
    AND EXISTS (
      SELECT 1 FROM txs_for_configs t
      WHERE t.tx_id = ic.tx_id
    )
),

/* NEW: bespoke events source, matched to the same date window and shaped like mint_transfer */
bespoke_events AS (
  SELECT DISTINCT
    CAST(be.call_block_time AS DATE) AS day_date,
    be.account_mint            AS token_mint_address
  FROM spl_token_solana.spl_token_call_initializeMint2 be
  JOIN params p ON TRUE
  WHERE be.call_tx_signer = 'DDT15s6MMNxE4jkyGN46wNYqrgLWofT6WAvWtjYYrCUq'
    AND be.call_block_time >= p.start_date
    AND be.call_block_time <  p.end_date + INTERVAL '1' DAY
),

/* Union both sources so a token/day is counted once even if it appears in both */
all_launch_events AS (
  SELECT day_date, token_mint_address FROM mint_transfer
  UNION
  SELECT day_date, token_mint_address FROM bespoke_events
),

excluded_tokens AS (
  SELECT token_mint_address FROM (VALUES
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

launches AS (
  SELECT
    day_date,
    COUNT(DISTINCT token_mint_address) AS daily_tokens_launched
  FROM all_launch_events
  WHERE token_mint_address NOT IN (SELECT token_mint_address FROM excluded_tokens)
  GROUP BY day_date
)

SELECT
  d.day_date AS date,
  COALESCE(l.daily_tokens_launched, 0) AS daily_tokens_launched
FROM days d
LEFT JOIN launches l
  ON l.day_date = d.day_date
ORDER BY date DESC;
