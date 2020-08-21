-- Verify stackexchange_api:badges/example_badge_triggers on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_catalog.pg_proc WHERE proname = 'autobio_badge'), 'Function autobio_badge was not created';

        ASSERT(SELECT 1 FROM pg_trigger WHERE tgname='autobio_check'), 'Trigger autobio_check was not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
