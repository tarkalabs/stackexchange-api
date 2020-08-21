-- Revert stackexchange_api:badges/example_badge_triggers from pg

BEGIN;

DROP FUNCTION stackdump_private.autobio_badge() CASCADE;

COMMIT;
