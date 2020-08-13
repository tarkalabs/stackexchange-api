-- Verify stackdump:comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'comments'), 'Comments table was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'comments_id_idx'), 'Comments id index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'comments_postid_idx'), 'Comments postId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'comments_userid_idx'), 'Comments userId index was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
