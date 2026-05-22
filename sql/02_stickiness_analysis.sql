WITH filtered_entries AS (
    SELECT entry_at::date AS entry_date
        , user_id
    FROM userentry
    WHERE 1 = 1
    AND user_id >= 94
    AND entry_at >= '2022-01-01'
    [[AND {{entry_at}}]]
      
      
)
, days as (
    SELECT DISTINCT entry_date AS day
    FROM filtered_entries
    )
    
, dau AS (
    SELECT
        entry_date::date AS day
        , COUNT(DISTINCT user_id) AS dau
    FROM filtered_entries
    GROUP BY 1
)

, mau AS (
    SELECT
        d.day
        , COUNT(DISTINCT fe.user_id) AS mau
    FROM days d
    JOIN filtered_entries fe
    ON fe.entry_date::date BETWEEN d.day - INTERVAL '29 days' AND d.day -- to grab unique users for 30d (including current day)
       AND fe.user_id >= 94
    GROUP BY 1
)

SELECT
    d.day
    , d.dau
    , m.mau
    , ROUND(d.dau::numeric / NULLIF(m.mau, 0) * 100, 2) AS stickiness_rate
FROM dau d
JOIN mau m USING (day)
ORDER BY d.day

