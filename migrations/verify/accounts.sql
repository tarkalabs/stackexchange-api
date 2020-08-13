-- Verify stackdump:accounts on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'accounts'), 'Accounts table does not exist.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'accounts_id_idx'), 'Account id index does not exist.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
