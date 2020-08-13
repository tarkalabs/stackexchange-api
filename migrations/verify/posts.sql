-- Verify stackdump:posts on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'posts'), 'Posts table was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posts_id_idx'), 'Posts id index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posts_posttypeid_idx'), 'Posts postTypeId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posts_acceptedanswerid_idx'), 'Posts acceptedAnswerId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posts_parentid_idx'), 'Posts parentId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posts_owneruserid_idx'), 'Posts ownerUserId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posts_lasteditoruserid_idx'), 'Posts lastEditorUserId index was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
