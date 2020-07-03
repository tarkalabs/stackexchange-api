-- Verify stackdump:post_functions on pg

BEGIN;

SELECT has_function_privilege('stackdump.submit_question(TEXT, INTEGER, TEXT, TEXT[])', 'execute');
SELECT has_function_privilege('stackdump.submit_answer(TEXT, INTEGER, INTEGER)', 'execute');
SELECT has_function_privilege('stackdump.delete_post(INTEGER, INTEGER)', 'execute');

ROLLBACK;
