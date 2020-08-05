-- Revert stackdump:post_triggers from pg

BEGIN;

DROP FUNCTION stackdump_private.post_create_trigger() CASCADE;
DROP FUNCTION stackdump_private.post_delete_trigger() CASCADE;
DROP FUNCTION stackdump_private.post_update_trigger() CASCADE;

DROP TRIGGER IF EXISTS before_post_insert ON stackdump.posts;
DROP FUNCTION IF EXISTS stackdump_private.check_parent();

COMMIT;
