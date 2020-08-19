-- Verify stackdump:votes on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'votes'), 'Votes table was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'votes_id_idx'), 'Votes id index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'votes_postid_idx'), 'Votes postId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'votes_votetypeid_idx'), 'Votes voteTypeId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'votes_userid_idx'), 'Votes userId index was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
