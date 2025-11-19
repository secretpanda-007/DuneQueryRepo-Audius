with dbc as (
    select
        SUM(TRY_CAST(total_fees_amount_raw as DECIMAL(38, 0))) as raw
        from dune.audius_team.result_dbc_fees
)
        , damm as (
        select
        SUM(TRY_CAST(total_fees_amount_raw as DECIMAL(38, 0))) as raw
        from dune.audius_team.result_dam_mv_2_fees_raw
        where token_fee_mint_address = '9LzCMqDgTKYz9Drzqnpgee3SGa89up3a247ypMj2xrqM'
)
        , bespoke as (
        select
        SUM(TRY_CAST(total_fees_amount_raw as DECIMAL(38, 0))) as raw
        from dune.audius_team.result_dam_mv_2_fees_raw
        where token_fee_mint_address = 'So11111111111111111111111111111111111111112'
)
        , stable as (
        select
        SUM(TRY_CAST(total_fees_amount_raw as DECIMAL(38, 0))) as raw
        from dune.audius_team.result_dam_mv_2_fees_raw
        where token_fee_mint_address = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v'
)
select
    COALESCE(dbc.raw, 0) + COALESCE(damm.raw, 0) as total_fees_amount_raw
    , CAST(COALESCE(dbc.raw, 0) + COALESCE(damm.raw, 0) as DECIMAL(38, 8)) / CAST(100000000 as DECIMAL(38, 8)) as total_fees_amount
, CAST(COALESCE(bespoke.raw, 0) as DECIMAL(38, 9)) / CAST(1000000000 as DECIMAL(38, 9)) as total_solana_fees -- ÷ 10^9 COALESCE(stable.raw  , 0) as total_usdc_fees_raw
    , CAST(COALESCE(stable.raw, 0) as DECIMAL(38, 6)) / CAST(1000000 as DECIMAL(38, 6)) as total_usdc_fees -- ÷ 10^6
from dbc
    cross join damm
    cross join bespoke
    cross join stable;
