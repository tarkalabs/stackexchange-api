-- Revert stackdump:accounts from pg

BEGIN;

DROP EXTENSION IF EXISTS "pgcrypto";
DROP TABLE stackdump_private.accounts;

COMMIT;
