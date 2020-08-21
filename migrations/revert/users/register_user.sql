-- Revert stackexchange_api:users/register_user from pg

BEGIN;

DROP FUNCTION stackdump.register_user(TEXT, TEXT);

COMMIT;