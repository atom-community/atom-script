-- To configure a SQL runner, use the following steps:
--
-- 1. Run "Script: Run Options" in Atom.
-- 2. Create a run profile that contains the following lines
--     For PostgreSQL:
--         Command: psql
--         Command Arguments: -h host -p port -d database -U user -q -f {FILE_ACTIVE}
--     For MySQL:
--         Command: mysql
--         Command Arguments: --host=host --user=user --password=password database < {FILE_ACTIVE}
-- 3. Use "Script: Run With Profile" and select this profile to run the active SQL file.

-- "Hello, world!" from SQL (PostgreSQL)

SELECT string_agg(w, ' ') AS welcome
FROM   (VALUES ('Hello'),
               ('World')) AS t(w);
