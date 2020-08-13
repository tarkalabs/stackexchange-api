-- Verify stackdump:postTypes on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'posttypes'), 'PostTypes table was not created.';
        ASSERT(SELECT COUNT(*) FROM stackdump.postTypes) = 8, 'Rows not added to PostTypes table.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
