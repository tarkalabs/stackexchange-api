-- Revert stackdump:appschema from pg

BEGIN;

DROP SCHEMA IF EXISTS stackdump;
DROP SCHEMA IF EXISTS stackdump_private;

COMMIT;
