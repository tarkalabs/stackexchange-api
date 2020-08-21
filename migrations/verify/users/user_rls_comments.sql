-- Verify stackexchange_api:users/user_rls_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.users'::regclass::oid), 1)))::boolean, 'Users id smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.users'::regclass::oid), 2)))::boolean, 'Users reputation smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.users'::regclass::oid), 3)))::boolean, 'Users creationDate smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.users'::regclass::oid), 5)))::boolean, 'Users lastAccessDate smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.users'::regclass::oid), 9)))::boolean, 'Users views smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.users'::regclass::oid), 10)))::boolean, 'Users upVotes smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.users'::regclass::oid), 11)))::boolean, 'Users downVotes smart comment not created.';
        ASSERT LENGTH((SELECT col_description((SELECT 'stackdump.users'::regclass::oid), 14)))::boolean, 'Users accountId smart comment not created.';
        ASSERT LENGTH((SELECT obj_description((SELECT 'stackdump.users'::regclass::oid), 'pg_class')))::boolean, 'Users table smart comment not created.';

        ASSERT(SELECT relrowsecurity FROM pg_class WHERE oid = (SELECT 'stackdump.users'::regclass::oid)), 'Row level security not activated on users table.';

        ASSERT(SELECT 1 FROM pg_policies WHERE policyname='policy_update_user'), 'Policy_update_user policy not created.';
        ASSERT(SELECT 1 FROM pg_policies WHERE policyname='policy_delete_user'), 'Policy_delete_user policy not created.';
        ASSERT(SELECT 1 FROM pg_policies WHERE policyname='policy_select_user'), 'Policy_select_user policy not created.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
