-- Verify stackdump:authentication on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'authenticate'), 'Function authenticate was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
