-- Verify stackexchange_api:badges/badges on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'badges'), 'Badges table was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'badges_id_idx'), 'Badges id index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'badges_userid_idx'), 'Badges userId index was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
