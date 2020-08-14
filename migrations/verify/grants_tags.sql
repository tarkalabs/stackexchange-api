-- Verify stackdump:grants_tgs on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.tags','select')), 'User_reg was not given permission to select tags.';
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.tags','select')), 'User_anon was not given permission to select tags.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
