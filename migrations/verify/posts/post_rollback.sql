-- Verify stackdump:post_rollback on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'post_rollback'), 'Function post_rollback was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
