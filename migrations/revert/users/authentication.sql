-- Revert stackexchange_api:users/authentication from pg

BEGIN;

DROP FUNCTION stackdump.authenticate(TEXT,TEXT);

COMMIT;
