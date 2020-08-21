-- Verify stackexchange_api:tags/tags on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'tags' AND schemaname = 'stackdump'), 'Tags table was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'tags_id_idx'), 'Tags id index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'tags_excerptpostid_idx'), 'Tags excerptPostId index was not created.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'tags_wikipostid_idx'), 'Tags wikiPostId index was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
