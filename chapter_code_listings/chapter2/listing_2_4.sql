--listing 2.4
SELECT
    ph.post_id,
    ph.user_id,
    DATE_TRUNC('day', ph.creation_date) AS activity_date,
    SUM(CASE WHEN ph.post_history_type_id IN (1,2,3)
		THEN 1 ELSE 0 END) AS total+created,
    SUM(CASE WHEN ph.post_history_type_id IN (4,5,6)
		THEN 1 ELSE 0 END) AS total_edited
FROM
    post_history ph
WHERE
    TRUE 
    AND ph.post_history_type_id BETWEEN 1 AND 6
    AND ph.user_id > 0 --exclude automated processes
    AND ph.user_id IS NOT NULL --exclude deleted accounts
    AND ph.creation_date >= '2021-12-01'
    AND ph.creation_date <= '2021-12-31'
    AND ph.post_id = 70182248
GROUP BY
    1,2,3;
