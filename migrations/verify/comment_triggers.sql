-- Verify stackdump:comment_triggers on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'inc_commentcount'), 'Function inc_commentCount was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'dec_commentcount'), 'Function dec_commentCount was not created.';

        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='comment_count_increment'), 'Trigger comment_count_increment was not created.';
        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='comment_count_increment'), 'Trigger comment_count_increment was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
