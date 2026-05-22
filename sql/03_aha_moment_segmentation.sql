

WITH user_segments AS (
    SELECT 
        u.id AS user_id
        , u.date_joined
        , COUNT(cs.id) FILTER (WHERE cs.is_false = 0 AND cs.created_at <= u.date_joined + INTERVAL '72 hours') AS successes
    FROM users u 
    LEFT JOIN codesubmit cs ON u.id = cs.user_id
    WHERE 1=1
    [[AND {{date_joined}}]]
    AND u.id >= 94 
    AND u.date_joined >= '2022-01-01' 
    GROUP BY 1, 2
)

, retained_30 AS (
    SELECT 
        DISTINCT ue.user_id 
    FROM userentry ue 
    JOIN user_segments us ON ue.user_id = us.user_id
    WHERE ue.entry_at >= us.date_joined + INTERVAL '30 days'
)


SELECT 
    CASE 
        WHEN successes >= 3 THEN 'Aha-moment Hit (3+)' 
        ELSE 'Aha-moment Miss' END AS segment
    , COUNT(us.user_id) AS user_cnt
    , ROUND(COUNT(r.user_id)::numeric / COUNT(us.user_id) * 100, 2) AS rr_d30
FROM user_segments us 
LEFT JOIN retained_30 r USING(user_id) GROUP BY 1;



