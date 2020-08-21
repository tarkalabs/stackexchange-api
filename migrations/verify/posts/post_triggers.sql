-- Verify stackexchange_api:posts/post_triggers on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'post_create_trigger'), 'Function post_create_trigger was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'post_delete_trigger'), 'Function post_delete_trigger was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'post_update_trigger'), 'Function post_update_trigger was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'check_parent'), 'Function check_parent was not created.';

        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='post_on_create'), 'Trigger post_on_create was not created.';
        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='post_on_delete'), 'Trigger post_on_delete was not created.';
        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='post_on_update'), 'Trigger post_on_update was not created.';
        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='before_post_insert'), 'Trigger before_post_insert was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
