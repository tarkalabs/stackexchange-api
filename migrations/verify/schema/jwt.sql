-- Verify stackexchange_api:schema/jwt on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM pg_type WHERE typname='jwt_token'), 'Type jwt_token was not created.';
    END;
$$ LANGUAGE PLPGSQL;

COMMIT;