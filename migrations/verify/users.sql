-- Verify stackdump:users on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'users'), 'Users table does not exist.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'users_id_idx'), 'Users id index does not exist.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'users_accountid_idx'), 'Users accountId index does not exist.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
