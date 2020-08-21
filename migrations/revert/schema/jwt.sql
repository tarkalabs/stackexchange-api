-- Revert stackexchange_api:schema/jwt from pg

BEGIN;

DROP TYPE stackdump.jwt_token;

COMMIT;