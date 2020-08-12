-- Verify stackdump:badges_rls_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.badges'::regclass::oid), 1)))::boolean;
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.badges'::regclass::oid), 2)))::boolean;
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.badges'::regclass::oid), 4)))::boolean;
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
