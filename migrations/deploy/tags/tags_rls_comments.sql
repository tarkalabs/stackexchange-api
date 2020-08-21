-- Deploy stackexchange_api:tags/tags_rls_comments to pg
-- requires: schema/appschema
-- requires: tags/tags
-- requires: schema/roles

BEGIN;

COMMENT ON COLUMN stackdump.tags.id IS E'@omit create,update';
COMMENT ON COLUMN stackdump.tags.count IS E'@omit create,update';

COMMIT;
