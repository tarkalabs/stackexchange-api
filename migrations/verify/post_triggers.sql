-- Verify stackdump:post_triggers on pg

BEGIN;

SELECT has_function_privilege('stackdump_private.post_create_trigger()', 'execute');
SELECT has_function_privilege('stackdump_private.post_delete_trigger()', 'execute');

SELECT * FROM pg_trigger WHERE tgname='before_post_insert';

ROLLBACK;
