WITH user_diffs AS (
    SELECT 
        ue.user_id
        , TO_CHAR(u.date_joined, 'YYYY-MM') AS cohort
        , EXTRACT(DAY FROM ue.entry_at - u.date_joined) AS diff
    FROM userentry ue
    JOIN users u ON ue.user_id = u.id
    WHERE 1 = 1
        [[AND {{date_joined}}]]     
        AND u.date_joined >= '2022-01-01' 
      AND u.id >= 94
      AND ue.entry_at >= u.date_joined
)

, cohort_sizes AS (
    SELECT 
        cohort
        , COUNT(DISTINCT user_id) AS total_users
    FROM user_diffs
    GROUP BY 1
)
SELECT
    ud.cohort
    , MAX(cs.total_users) as users_count
    , ROUND(COUNT(DISTINCT user_id) FILTER (WHERE diff >= 0) * 100.0 / MAX(cs.total_users), 2) AS "0(%)"
    , ROUND(COUNT(DISTINCT user_id) FILTER (WHERE diff >= 1) * 100.0 / MAX(cs.total_users), 2) AS "1(%)"
    , ROUND(COUNT(DISTINCT user_id) FILTER (WHERE diff >= 3) * 100.0 / MAX(cs.total_users), 2) AS "3(%)"
    , ROUND(COUNT(DISTINCT user_id) FILTER (WHERE diff >= 7) * 100.0 / MAX(cs.total_users), 2) AS "7(%)"
    , ROUND(COUNT(DISTINCT user_id) FILTER (WHERE diff >= 30) * 100.0 / MAX(cs.total_users), 2) AS "30(%)"
    , ROUND(COUNT(DISTINCT user_id) FILTER (WHERE diff >= 90) * 100.0 / MAX(cs.total_users), 2) AS "90(%)"
FROM user_diffs ud
JOIN cohort_sizes cs ON ud.cohort = cs.cohort
GROUP BY 1
ORDER BY 1