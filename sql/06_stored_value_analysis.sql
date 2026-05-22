WITH calendar AS (
    SELECT generate_series(
        '2022-01-01'::date,
        CURRENT_DATE,
        interval '1 day'
    )::date AS day
)

, daily_balance AS (
    SELECT
        user_id
        , created_at::date AS day
        , SUM(CASE
                WHEN type_id = 29 or type_id BETWEEN 2 AND 22 THEN value
                WHEN type_id = 1 or type_id BETWEEN 23 AND 28 THEN - value
                ELSE 0 END) AS delta
    FROM transaction
    WHERE user_id >= 94
      AND value < 500
      AND created_at >= '2022-01-01'
    GROUP BY 1, 2
)

, cumulative_balance AS (
    SELECT
        user_id
        , day
        , SUM(delta) OVER (PARTITION BY user_id ORDER BY day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS balance
    FROM  daily_balance
) 

, user_calendar AS (
    SELECT
        u.id AS user_id,
        c.day
    FROM users u
    JOIN calendar c
      ON c.day >= u.date_joined
    WHERE 1 =1 
    AND u.id >= 94
    [[AND c.day BETWEEN {{date.start}} and {{date.end}}]]
)

, user_cumu_balance AS (
    SELECT
        uc.user_id
        , uc.day
        , MAX(b.balance) FILTER (WHERE b.day < uc.day)
            OVER (PARTITION BY uc.user_id ORDER BY uc.day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS start_of_day_balance
    FROM user_calendar uc
    LEFT JOIN cumulative_balance b
        ON b.user_id = uc.user_id
       AND b.day < uc.day
)

, daily_segments AS (
    SELECT
        day
        , user_id
        , CASE 
            WHEN start_of_day_balance IS NULL THEN 'No balance yet'
            WHEN COALESCE(start_of_day_balance, 0) <= 0 THEN '0: Empty'
            WHEN start_of_day_balance BETWEEN 1 AND 10 THEN '1-10: Low'
            WHEN start_of_day_balance BETWEEN 11 AND 50 THEN '11-50: Moderate'
            WHEN start_of_day_balance BETWEEN 51 AND 100 THEN '51-100: High'
            WHEN start_of_day_balance BETWEEN 101 AND 150 THEN '101-150: Saver'
            ELSE '151+: Investor'
        END AS coin_segment
    FROM user_cumu_balance
)

-- select distinct coin_segment, count(*) from daily_segments group by 1
-- DAU
, dau AS (
    SELECT
        ds.day
        , ds.coin_segment
        , COUNT(DISTINCT ds.user_id) AS dau
    FROM daily_segments ds
    JOIN userentry ue
        ON ue.user_id = ds.user_id
       AND ue.entry_at::date = ds.day
    GROUP BY 1, 2
)


-- MAU
, mau AS (
    SELECT
        ds.day
        , ds.coin_segment
        , COUNT(DISTINCT ue.user_id) AS mau
    FROM daily_segments ds
    JOIN userentry ue
        ON ue.user_id = ds.user_id
       AND ue.entry_at::date BETWEEN ds.day - INTERVAL '29 days' AND ds.day
    GROUP BY 1, 2
)


-- Stickiness
SELECT
    m.coin_segment
    , ROUND(AVG(d.dau), 0) AS avg_dau
    , ROUND(AVG(m.mau), 0) AS avg_mau
    , ROUND(AVG(d.dau::numeric / NULLIF(m.mau, 0)) * 100, 2) AS stickiness_rate
FROM mau m
LEFT JOIN dau d
    USING (day, coin_segment)
GROUP BY 1
ORDER BY CASE coin_segment
    WHEN 'No balance yet'  THEN 1
    WHEN '0: Empty'       THEN 2
    WHEN '1-10: Low'      THEN 3
    WHEN '11-50: Moderate' THEN 4
    WHEN '51-100: High'    THEN 5
    WHEN '101-150: Saver'  THEN 6
    WHEN '151+: Investor' THEN 7
    ELSE 8
END;

