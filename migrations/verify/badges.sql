-- Verify stackdump:badges on pg

BEGIN;

SELECT id, userId, name
    FROM stackdump.badges
    WHERE FALSE;

SELECT 'stackdump.badges_id_idx'::regclass;
SELECT 'stackdump.badges_userId_idx'::regclass;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'badges'), 'Badges table does not exist.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'badges_id_idx'), 'Badges id index does not exist.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'badges_userid_idx'), 'Badges userId index does not exist.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
