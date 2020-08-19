-- Verify stackdump:voteTypes on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'votetypes'), 'VoteTypes table was not created.';
        ASSERT(SELECT COUNT(*) FROM stackdump.VoteTypes) = 14, 'Rows not added to VoteTypes table.';
    END;
$$ LANGUAGE PLPGSQL;
ROLLBACK;
