-- Verify stackdump:appschema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('stackdump', 'usage');
SELECT pg_catalog.has_schema_privilege('stackdump_private', 'usage');
SELECT pg_catalog.has_schema_privilege('extensions', 'usage');

SELECT pg_catalog.has_function_privilege('extensions.crypt(TEXT,TEXT)', 'execute');
SELECT pg_catalog.has_function_privilege('extensions.uuid_generate_v4()', 'execute');

ROLLBACK;
