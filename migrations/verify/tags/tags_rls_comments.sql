-- Verify stackdump:tags_rls_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.tags'::regclass::oid), 1)))::boolean, 'Tags id smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.tags'::regclass::oid), 3)))::boolean, 'Tags count smart comment not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
