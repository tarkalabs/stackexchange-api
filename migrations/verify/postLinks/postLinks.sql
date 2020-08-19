-- Verify stackdump:postLinks on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'postlinks'), 'PostLinks table was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'postlinks_id_idx'), 'PostLinks id index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'postlinks_postid_idx'), 'PostLinks postId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'postlinks_relatedpostid_idx'), 'PostLinks relatedPostId index was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
