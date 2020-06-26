-- Revert stackdump:appschema from pg

BEGIN;

DROP EXTENSION IF EXISTS "pgcrypto";
DROP SCHEMA IF EXISTS stackdump CASCADE;
DROP SCHEMA IF EXISTS stackdump_private CASCADE;

COMMIT;
