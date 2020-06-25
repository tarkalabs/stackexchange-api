-- Revert stackdump:accounts from pg

BEGIN;

DROP TABLE stackdump_private.accounts;

COMMIT;
