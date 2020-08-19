-- Verify stackdump:grants_badges on pg

BEGIN;

DO $$
    BEGIN
        ASSERT(SELECT has_table_privilege('user_reg','stackdump.badges','select')), 'User_reg was not given permission to select badges.';
        ASSERT(SELECT has_table_privilege('user_anon','stackdump.badges','select')), 'User_anon was not given permission to select badges.';
    END;
$$ LANGUAGE PLPGSQL;

ROLLBACK;
