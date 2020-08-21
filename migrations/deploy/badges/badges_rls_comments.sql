-- Deploy stackexchange_api:badges/badges_rls_comments to pg
-- requires: schema/appschema
-- requires: badges/badges
-- requires: schema/roles

BEGIN;

COMMENT ON COLUMN stackdump.badges.id IS E'@omit create,update';
COMMENT ON COLUMN stackdump.badges.userId IS E'@omit create,update';
COMMENT ON COLUMN stackdump.badges.date IS E'@omit create,update';

COMMIT;
