-- Verify stackexchange_api:posts/text_search on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_attribute WHERE attname = 'textsearch_index_col' AND attrelid=(SELECT 'stackdump.posts'::regclass::oid)), 'Column textsearch_index_col not added to posts table.';
        ASSERT(SELECT 1 FROM pg_indexes WHERE indexname = 'posts_textsearch_idx'), 'Text search index posts_textsearch_idx was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'posts_tsvector_trigger'), 'Function posts_tsvector_trigger was not created.';
        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='tsvectorupdate'), 'Trigger tsvectorupdate was not created.';
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'ranked_search'), 'Function ranked_search was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
