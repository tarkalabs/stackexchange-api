-- Verify stackexchange_api:postHistory/postHistoryTypes on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'posthistorytypes'), 'PostHistoryTypes table was not created.';
        ASSERT(SELECT COUNT(*) FROM stackdump.postHistoryTypes) = 40, 'Rows not added to PostHistoryTypes table.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
