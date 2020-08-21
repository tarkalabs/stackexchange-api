-- Verify stackexchange_api:votes/vote_triggers on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'vote_create_trigger'), 'Function vote_create_trigger was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'vote_delete_trigger'), 'Function vote_delete_trigger was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'check_votes'), 'Function check_votes was not created.';

        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='vote_on_create'), 'Trigger vote_on_create was not created.';
        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='vote_on_delete'), 'Trigger vote_on_delete was not created.';
        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='before_vote_insert'), 'Trigger before_vote_insert was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
