-- Verify stackdump:grants_posttypes on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.posttypes','select')), 'User_reg was not given permission to select postTypes.';
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.posttypes','select')), 'User_anon was not given permission to select postTypes.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
