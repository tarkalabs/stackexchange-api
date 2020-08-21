-- Revert stackexchange_api:users/accounts from pg

BEGIN;

DROP INDEX stackdump_private.accounts_id_idx;
DROP TABLE stackdump_private.accounts;

COMMIT;
