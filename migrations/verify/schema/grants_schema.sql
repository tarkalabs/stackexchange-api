-- Verify stackexchange_api:schema/grants_schema on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_schema_privilege('user_anon','stackdump','usage')), 'User_anon was not given access to schema stackdump.';
        ASSERT(SELECT has_schema_privilege('user_reg','stackdump','usage')), 'User_reg was not given access to schema stackdump.';
        ASSERT(SELECT has_schema_privilege('user_anon','extensions','usage')), 'User_anon was not given access to schema extensions.';
        ASSERT(SELECT has_schema_privilege('user_reg','extensions','usage')), 'User_reg was not given access to schema extensions.';
        ASSERT(SELECT has_function_privilege('user_anon', 'stackdump.register_user(text,text)','execute')), 'User_anon was not given access to function register_user.';
        ASSERT(SELECT has_function_privilege('user_anon', 'stackdump.authenticate(text,text)','execute')), 'User_anon was not given access to function authenticate.';
        ASSERT(SELECT has_function_privilege('user_anon','stackdump.register_superuser(text)','execute')), 'User_anon was not given access to function register_superuser.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
