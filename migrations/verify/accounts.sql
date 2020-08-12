-- Verify stackdump:accounts on pg

BEGIN;

SELECT id, username
    FROM stackdump_private.accounts
    WHERE FALSE;

SELECT 'stackdump_private.accounts_id_idx'::regclass;

ROLLBACK;
