-- Verify stackexchange_api:users/grants_user on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.users','select')), 'User_reg was not given permission to select users.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.users','update')), 'User_reg was not given permission to update users.';
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.users','delete')), 'User_reg was not given permission to delete users.';
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.users','select')), 'User_anon was not given permission to select users.';
        ASSERT(SELECT 1 FROM information_schema.usage_privileges WHERE grantee='user_reg' AND object_name='users_id_seq'), 'User_reg was not granted usage of sequence users_id_seq.';
        ASSERT(SELECT array_to_string((SELECT relacl FROM pg_class WHERE relname='users_id_seq'), ',') ~ '.*user_reg=r.*'), 'User_reg was not granted select privileges on sequence users_id_seq';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
