-- Revert stackdump:vote_triggers from pg

BEGIN;

DROP FUNCTION stackdump_private.vote_create_trigger() CASCADE;
DROP FUNCTION stackdump_private.vote_delete_trigger() CASCADE;
DROP TRIGGER IF EXISTS before_vote_insert ON stackdump.votes;
DROP FUNCTION IF EXISTS stackdump_private.check_votes();

COMMIT;
