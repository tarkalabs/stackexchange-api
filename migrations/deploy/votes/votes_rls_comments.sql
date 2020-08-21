-- Deploy stackexchange_api:votes/votes_rls_comments to pg
-- requires: schema/appschema
-- requires: votes/votes
-- requires: schema/roles

BEGIN;

COMMENT ON COLUMN stackdump.votes.id IS E'@omit create,update';
COMMENT ON COLUMN stackdump.votes.userId IS E'@omit create,update';
COMMENT ON COLUMN stackdump.votes.bountyAmount IS E'@omit create,update';
COMMENT ON COLUMN stackdump.votes.creationDate IS E'@omit create,update';


COMMIT;
