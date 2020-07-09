-- Deploy stackdump:text_search to pg
-- requires: dataRows
-- requires: posts
-- requires: appschema

BEGIN;

ALTER TABLE stackdump.posts ADD COLUMN textsearch_index_col TSVECTOR;
UPDATE stackdump.posts SET textsearch_index_col =
    setweight(to_tsvector(COALESCE(title,'')), 'A') ||
    setweight(to_tsvector(COALESCE(ARRAY_TO_STRING(tags, ' '),'')), 'B') ||
    setweight(to_tsvector(COALESCE(body,'')), 'C');
CREATE INDEX posts_textsearch_idx ON stackdump.posts USING GIN(textsearch_index_col);

CREATE FUNCTION stackdump_private.posts_tsvector_trigger() RETURNS TRIGGER AS $$
BEGIN
  new.textsearch_index_col :=
     setweight(to_tsvector('pg_catalog.english', COALESCE(new.title,'')), 'A') ||
     setweight(to_tsvector('pg_catalog.english', COALESCE(ARRAY_TO_STRING(new.tags, ' '), '')), 'B') ||
     setweight(to_tsvector('pg_catalog.english', COALESCE(new.body,'')), 'C');
  return new;
END
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
    ON stackdump.posts FOR EACH ROW EXECUTE PROCEDURE
    stackdump_private.posts_tsvector_trigger();

CREATE OR REPLACE FUNCTION stackdump.ranked_search(
    terms TEXT
) RETURNS TABLE(id INTEGER, title TEXT, rank REAL) AS $$
    BEGIN
        RETURN QUERY
        SELECT posts.id AS id, posts.title AS title, ts_rank_cd(textsearch_index_col, query) AS rank
            FROM stackdump.posts, to_tsquery(terms) query
            WHERE query @@ textsearch_index_col
            ORDER BY rank DESC LIMIT 10;
    END;
$$ LANGUAGE PLPGSQL;

COMMIT;