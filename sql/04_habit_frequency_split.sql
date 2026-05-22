WITH user_w1_activity AS (
    SELECT 
        u.id AS user_id
        , u.date_joined
        , COUNT(DISTINCT ue.entry_at::date) AS active_days_w1
    FROM users u
    LEFT JOIN userentry ue ON u.id = ue.user_id 
        AND ue.entry_at <= u.date_joined + INTERVAL '7 days'
    WHERE 1=1
    AND u.id >= 94 
    AND u.date_joined >= '2022-01-01'
    [[AND {{date_joined}}]]
    GROUP BY 1
)
, retention_d30 AS (
    SELECT 
        DISTINCT ue.user_id 
    FROM userentry ue 
    JOIN user_w1_activity uwa ON ue.user_id = uwa.user_id
    WHERE ue.entry_at >= uwa.date_joined + INTERVAL '30 days'
)

SELECT 
    active_days_w1
    , COUNT(uwa.user_id) as group_size
    , ROUND(COUNT(rd.user_id)::numeric / COUNT(uwa.user_id) * 100, 2) AS d30_retention_rate
FROM user_w1_activity uwa 
LEFT JOIN retention_d30 rd USING(user_id)
GROUP BY 1 