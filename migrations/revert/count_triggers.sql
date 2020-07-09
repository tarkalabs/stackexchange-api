-- Revert stackdump:count_triggers from pg

BEGIN;

DROP FUNCTION stackdump_private.inc_commentCount() CASCADE;
DROP FUNCTION stackdump_private.dec_commentCount() CASCADE;
DROP FUNCTION stackdump_private.post_create_trigger() CASCADE;
DROP FUNCTION stackdump_private.post_delete_trigger() CASCADE;
DROP FUNCTION stackdump_private.vote_create_trigger() CASCADE;
DROP FUNCTION stackdump_private.vote_delete_trigger() CASCADE;

COMMIT;
