-- Deploy stackdump:appschema to pg

BEGIN;

CREATE SCHEMA stackdump;
CREATE SCHEMA stackdump_private;

CREATE SCHEMA extensions;
CREATE EXTENSION "pgcrypto" SCHEMA extensions;
COMMIT;
