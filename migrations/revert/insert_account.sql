-- Revert stackdump:insert_account from pg

BEGIN;

DROP FUNCTION stackdump.insert_account(INTEGER);
DROP FUNCTION stackdump.insert_account(TEXT, TEXT);

COMMIT;
