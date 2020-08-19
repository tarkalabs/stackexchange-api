-- Verify stackdump:register_superuser on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'register_superuser'), 'Function register_superuser was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
