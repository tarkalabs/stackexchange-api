-- Verify stackdump:post_rollback on pg

BEGIN;

SELECT has_function_privilege('stackdump.post_rollback(TEXT)', 'execute');

ROLLBACK;
