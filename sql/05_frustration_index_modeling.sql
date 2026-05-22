WITH raw_events AS (
    SELECT 
        user_id
        , problem_id
        , created_at
        , 'run' AS event_type
        , 0 AS is_success
    FROM coderun
    WHERE 1 = 1
    AND user_id >= 94 AND created_at >= '2022-01-01'
    [[AND {{created_at}} ]]
    UNION ALL
    SELECT 
        user_id
        , problem_id
        , created_at, 'submit' AS event_type
        , CASE WHEN is_false = 0 THEN 1 ELSE 0 END AS is_success
    FROM codesubmit
    WHERE 1 = 1
    AND user_id >= 94 AND created_at >= '2022-01-01'
    [[AND {{created_at}} ]]
)

, trajectories AS (
    SELECT
        , problem_id
        , created_at
        , event_type
        , is_success
        , ROW_NUMBER() OVER (PARTITION BY user_id, problem_id ORDER BY created_at) AS step_num
        , MIN(CASE WHEN is_success = 1 THEN created_at END) OVER (PARTITION BY user_id, problem_id) AS first_success_ts
        , MAX(created_at) OVER (PARTITION BY user_id, problem_id) AS last_event_ts
    FROM raw_events
)

, final_states AS (
    SELECT
        user_id
        , problem_id
        , MAX(step_num) AS max_step 
        , MIN(step_num) FILTER (WHERE is_success = 1) AS success_step 
    FROM trajectories
    GROUP BY 1,2
)

, expanded_steps AS (
    SELECT
        fs.user_id
        , fs.problem_id
        , generate_series(1, fs.max_step) AS step_num
        , fs.success_step
        , fs.max_step
    FROM final_states fs
)

, step_outcomes AS (
    SELECT
        step_num
        , COUNT(*) AS population_at_risk 
        , COUNT(*) FILTER (WHERE success_step = step_num) AS success_at_step
        , COUNT(*) FILTER (WHERE success_step IS NULL AND max_step = step_num) AS abandoned_at_step
    FROM expanded_steps
    WHERE step_num <= 15
    GROUP BY step_num
)

SELECT
    step_num
    , population_at_risk AS "Population at Risk"
    , ROUND(success_at_step::numeric / population_at_risk * 100, 2) AS "Success Rate (%)" 
    , ROUND(abandoned_at_step::numeric / population_at_risk * 100, 2) AS "Abandon Rate (%)" 
ORDER BY step_num;
