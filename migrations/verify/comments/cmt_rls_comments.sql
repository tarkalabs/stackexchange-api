-- Verify stackdump:cmt_rls_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.comments'::regclass::oid), 1)))::boolean, 'Comments id smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.comments'::regclass::oid), 3)))::boolean, 'Comments score smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.comments'::regclass::oid), 5)))::boolean, 'Comments creationDate smart comment not created.';

        ASSERT (SELECT relrowsecurity FROM pg_class WHERE oid = (SELECT 'stackdump.comments'::regclass::oid)), 'Row level security not activated on comments table.';

        ASSERT (SELECT 1 FROM pg_policies WHERE policyname='policy_insert_comments'), 'Policy_insert_comments policy not created.';
        ASSERT (SELECT 1 FROM pg_policies WHERE policyname='policy_delete_comments'), 'Policy_delete_comments policy not created.';
        ASSERT (SELECT 1 FROM pg_policies WHERE policyname='policy_update_comments'), 'Policy_update_comments policy not created.';
        ASSERT (SELECT 1 FROM pg_policies WHERE policyname='policy_select_comments'), 'Policy_select_comments policy not created.';
    END;
$$ LANGUAGE PLPGSQL;



ROLLBACK;
