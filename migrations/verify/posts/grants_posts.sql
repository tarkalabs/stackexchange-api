-- Verify stackexchange_api:posts/grants_posts on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posts','select')), 'User_reg was not given permission to select posts.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posts','insert')), 'User_reg was not given permission to insert posts.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posts','update')), 'User_reg was not given permission to update posts.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posts','delete')), 'User_reg was not given permission to delete posts.';
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.posts','select')), 'User_anon was not given permission to select posts.';
        ASSERT(SELECT 1 FROM information_schema.usage_privileges WHERE grantee='user_anon' AND object_name='posts_id_seq'), 'User_anon was not granted usage of sequence posts_id_seq.';
        ASSERT(SELECT 1 FROM information_schema.usage_privileges WHERE grantee='user_reg' AND object_name='posts_id_seq'), 'User_reg was not granted usage of sequence posts_id_seq.';
        ASSERT(SELECT array_to_string((SELECT relacl FROM pg_class WHERE relname='posts_id_seq'), ',') ~ '.*user_anon=r.*'), 'User_anon was not granted select privileges on sequence posts_id_seq';
        ASSERT(SELECT array_to_string((SELECT relacl FROM pg_class WHERE relname='posts_id_seq'), ',') ~ '.*user_reg=r.*'), 'User_reg was not granted select privileges on sequence posts_id_seq';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
