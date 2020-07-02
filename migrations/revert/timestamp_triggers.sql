-- Revert stackdump:timestamp_triggers from pg

BEGIN;

DROP FUNCTION stackdump_private.set_lastEditDate() CASCADE;
DROP FUNCTION stackdump_private.set_lastActivityDate() CASCADE;
--DROP TRIGGER IF EXISTS post_edited_at;
--DROP TRIGGER IF EXISTS post_activity_at;

COMMIT;
