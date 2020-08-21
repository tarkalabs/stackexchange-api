-- Verify stackexchange_api:posts/post_view on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_attribute WHERE attname = 'deleted' AND attrelid=(SELECT 'stackdump.posts'::regclass::oid)), 'Column deleted not added to posts table.';
        ASSERT(SELECT (SELECT 1 FROM stackdump.posts WHERE deleted = TRUE) IS NULL), 'A post could not be set to deleted = FALSE';
        ASSERT(SELECT 1 FROM pg_catalog.pg_views WHERE viewname = 'post_view' AND schemaname = 'stackdump'), 'View post_view not created.';
    END;
$$ LANGUAGE PLPGSQL;

SELECT deleted
    FROM stackdump.posts
    WHERE FALSE;

SELECT * FROM stackdump.post_view LIMIT 1;

ROLLBACK;
