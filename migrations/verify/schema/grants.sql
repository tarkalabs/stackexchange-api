-- Verify stackdump:grants on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_schema_privilege('user_anon','stackdump','usage')), 'User_anon was not given access to schema stackdump.';
        ASSERT(SELECT has_schema_privilege('user_reg','stackdump','usage')), 'User_reg was not given access to schema stackdump.';
        ASSERT(SELECT has_schema_privilege('user_anon','extensions','usage')), 'User_anon was not given access to schema extensions.';
        ASSERT(SELECT has_schema_privilege('user_reg','extensions','usage')), 'User_reg was not given access to schema extensions.';
        ASSERT(SELECT has_function_privilege('user_anon', 'stackdump.register_user(text,text)','execute')), 'User_anon was not given access to function register_user.';
        ASSERT(SELECT has_function_privilege('user_anon', 'stackdump.authenticate(text,text)','execute')), 'User_anon was not given access to function authenticate.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posts','select')), 'User_reg was not given permission to select posts.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posts','insert')), 'User_reg was not given permission to insert posts.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posts','update')), 'User_reg was not given permission to update posts.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posts','delete')), 'User_reg was not given permission to delete posts.';
        ASSERT(SELECT has_function_privilege('user_anon','stackdump.register_superuser(text)','execute')), 'User_anon was not given access to function register_superuser.';
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.posts','select')), 'User_anon was not given permission to select posts.';
        ASSERT(SELECT 1 FROM information_schema.usage_privileges WHERE grantee='user_anon' AND object_name='posts_id_seq'), 'User_anon was not granted usage of sequence posts_id_seq.';
        ASSERT(SELECT 1 FROM information_schema.usage_privileges WHERE grantee='user_reg' AND object_name='posts_id_seq'), 'User_reg was not granted usage of sequence posts_id_seq.';
        ASSERT(SELECT array_to_string((SELECT relacl FROM pg_class WHERE relname='posts_id_seq'), ',') ~ '.*user_anon=r.*'), 'User_anon was not granted select privileges on sequence posts_id_seq';
        ASSERT(SELECT array_to_string((SELECT relacl FROM pg_class WHERE relname='posts_id_seq'), ',') ~ '.*user_reg=r.*'), 'User_reg was not granted select privileges on sequence posts_id_seq';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
