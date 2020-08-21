-- Revert stackexchange_api:posts/post_rollback from pg

BEGIN;

DROP FUNCTION stackdump.post_rollback(TEXT);

COMMIT;
