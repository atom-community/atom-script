-- "Hello, world!" from SQL (PostgreSQL)

SELECT string_agg(w, ' ') AS welcome
FROM   (VALUES ('Hello'),
               ('World')) AS t(w);
