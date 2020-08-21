-- Verify stackexchange_api:posts/timestamp_triggers on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'set_lasteditdate'), 'Function set_lasteditdate was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'set_lastactivitydate'), 'Function set_lastactivitydate was not created.';

        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='post_edited_at'), 'Trigger post_edited_at was not created.';
        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='post_activity_at'), 'Trigger post_activity_at was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
