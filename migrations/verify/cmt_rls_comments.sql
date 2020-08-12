-- Verify stackdump:cmt_rls_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.comments'::regclass::oid), 1)))::boolean;
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.comments'::regclass::oid), 3)))::boolean;
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.comments'::regclass::oid), 5)))::boolean;

        ASSERT (SELECT relrowsecurity FROM pg_class WHERE oid = (SELECT 'stackdump.comments'::regclass::oid));

        ASSERT (SELECT 1 FROM pg_policies WHERE policyname='policy_insert_comments');
        ASSERT (SELECT 1 FROM pg_policies WHERE policyname='policy_delete_comments');
        ASSERT (SELECT 1 FROM pg_policies WHERE policyname='policy_update_comments');
        ASSERT (SELECT 1 FROM pg_policies WHERE policyname='policy_select_comments');
    END;
$$ LANGUAGE PLPGSQL;



ROLLBACK;
