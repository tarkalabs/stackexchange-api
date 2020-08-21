-- Verify stackexchange_api:schema/appschema on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM information_schema.schemata WHERE schema_name = 'stackdump'), 'Schema stackdump was not created.';
        ASSERT(SELECT 1 FROM information_schema.schemata WHERE schema_name = 'stackdump_private'), 'Schema stackdump_private was not created.';
        ASSERT(SELECT 1 FROM information_schema.schemata WHERE schema_name = 'extensions'), 'Schema extensions was not created.';

        ASSERT(SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto'), 'Extension pgcrypto was not installed.';
        ASSERT(SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp'), 'Extension uuid-ossp was not installed.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
