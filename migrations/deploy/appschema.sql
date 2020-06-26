-- Deploy stackdump:appschema to pg

BEGIN;

CREATE SCHEMA stackdump;
CREATE SCHEMA stackdump_private;
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

COMMIT;
