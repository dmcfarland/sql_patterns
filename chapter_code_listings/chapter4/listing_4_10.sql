--listing 4.10
WITH cte_lowercase_tags AS (
	SELECT
	    q.id AS post_id,
	    q.creation_date,
	    LOWER(q.tags) as tags
	FROM
	    posts_questions q
)
SELECT *
FROM cte_lowercase_tags
WHERE tags LIKE '%sql%'
LIMIT 10;
