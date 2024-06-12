--listing 3.3
WITH post_activity AS (
    SELECT
        ph.post_id,
        ph.user_id,
        u.display_name AS user_name,
        ph.creation_date AS activity_date,
        CASE WHEN ph.post_history_type_id IN (1,2,3) THEN 'create'
             WHEN ph.post_history_type_id IN (4,5,6) THEN 'edit' 
        END AS activity_type
    FROM
        post_history ph
        INNER JOIN users u 
			ON u.id = ph.user_id
    WHERE
        TRUE
        AND ph.post_history_type_id BETWEEN 1 AND 6
        AND user_id > 0 --exclude automated processes
        AND user_id IS NOT NULL --exclude deleted accounts
    GROUP BY
        1,2,3,4,5
),
post_types AS (
    SELECT
        id AS post_id,
        'question' AS post_type,
    FROM
        posts_questions
    UNION ALL
    SELECT
        id AS post_id,
        'answer' AS post_type,
    FROM
        posts_answers
)
SELECT
    user_id,
    CAST(pa.activity_date AS DATE) AS activity_dt,
    SUM(CASE WHEN activity_type = 'create'
        AND post_type = 'question' THEN 1 ELSE 0 END) AS question_create,
    SUM(CASE WHEN activity_type = 'create'
        AND post_type = 'answer'   THEN 1 ELSE 0 END) AS answer_create,
    SUM(CASE WHEN activity_type = 'edit'
        AND post_type = 'question' THEN 1 ELSE 0 END) AS question_edit,
    SUM(CASE WHEN activity_type = 'edit'
        AND post_type = 'answer'   THEN 1 ELSE 0 END) AS answer_edit  
FROM post_activity pa
     JOIN post_types pt ON pt.post_id = pa.post_id
WHERE user_id = 4603670
GROUP BY 1,2
LIMIT 10;
