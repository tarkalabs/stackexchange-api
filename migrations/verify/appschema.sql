-- Verify stackdump:appschema on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT 1 FROM information_schema.schemata WHERE schema_name = 'stackdump'), 'Schema stackdump does not exist.';
        ASSERT(SELECT 1 FROM information_schema.schemata WHERE schema_name = 'stackdump_private'), 'Schema stackdump_private does not exist.';
        ASSERT(SELECT 1 FROM information_schema.schemata WHERE schema_name = 'extensions'), 'Schema extensions does not exist.';

        ASSERT(SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto'), 'Extension pgcrypto was not installed.';
        ASSERT(SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp'), 'Extension uuid-ossp was not installed.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
