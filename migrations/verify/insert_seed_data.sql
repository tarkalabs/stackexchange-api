-- Verify stackdump:insert_seed_data on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_account'), 'Function insert_seed_account was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_answer'), 'Function insert_seed_answer was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_badge'), 'Function insert_seed_badge was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_comment'), 'Function insert_seed_comment was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_post'), 'Function insert_seed_post was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_posthistory'), 'Function insert_seed_postHistory was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_postlink'), 'Function insert_seed_postlink was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_tag'), 'Function insert_seed_tag was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_user'), 'Function insert_seed_user was not created';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'insert_seed_vote'), 'Function insert_seed_vote was not created';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
