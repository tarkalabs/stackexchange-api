-- Verify stackexchange_api:postHistory/postHistory on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'posthistory'), 'PostHistory table was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posthistory_id_idx'), 'PostHistory id index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posthistory_posthistorytypeid_idx'), 'PostHistory postHistoryTypeId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posthistory_postid_idx'), 'PostHistory postId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posthistory_userid_idx'), 'PostHistory userId index was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
