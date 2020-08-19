-- Verify stackdump:badges_rls_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.badges'::regclass::oid), 1)))::boolean, 'Badges id smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.badges'::regclass::oid), 2)))::boolean, 'Badges userId smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.badges'::regclass::oid), 4)))::boolean, 'Badges date smart comment not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
