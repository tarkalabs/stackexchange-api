-- Deploy stackdump:appschema to pg

BEGIN;

CREATE SCHEMA stackdump;
CREATE SCHEMA stackdump_private;
CREATE SCHEMA stackdump_extensions;
CREATE EXTENSION "pgcrypto" SCHEMA stackdump_extensions;

COMMIT;
