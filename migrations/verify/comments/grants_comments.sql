-- Verify stackexchange_api:comments/grants_comments on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.comments','insert')), 'User_reg was not given permission to insert comments.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.comments','select')), 'User_reg was not given permission to select comments.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.comments','update')), 'User_reg was not given permission to update comments.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.comments','delete')), 'User_reg was not given permission to delete comments.';
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.comments','select')), 'User_anon was not given permission to select comments.';
        ASSERT(SELECT 1 FROM information_schema.usage_privileges WHERE grantee='user_reg' AND object_name='comments_id_seq'), 'User_reg was not granted usage of sequence comments_id_seq.';
        ASSERT(SELECT array_to_string((SELECT relacl FROM pg_class WHERE relname='comments_id_seq'), ',') ~ '.*user_reg=r.*'), 'User_reg was not granted select privileges on sequence comments_id_seq';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
