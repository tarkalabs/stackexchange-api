-- Verify stackdump:users on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'users'), 'Users table was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'users_id_idx'), 'Users id index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'users_accountid_idx'), 'Users accountId index was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
