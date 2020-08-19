-- Verify stackdump:register_user on pg
BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'register_user'), 'Function register_user was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;