-- Verify stackdump:insert_account on pg

BEGIN;

SELECT has_function_privilege('stackdump.insert_account(INTEGER)', 'execute');
SELECT has_function_privilege('stackdump.insert_account(TEXT, TEXT)', 'execute');

ROLLBACK;
